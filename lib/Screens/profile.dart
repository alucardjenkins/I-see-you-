import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:load_monitoring_mobile_app/Screens/change_email.dart';
import 'package:load_monitoring_mobile_app/Screens/change_password_page.dart';
import '../main.dart'; // for kPrimaryGreen

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _avatarFile;
  bool _editingUsername = false;
  final ImagePicker _picker = ImagePicker();
  late String _username;
  late String _email;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser!;
    _username = user.displayName ?? user.email!.split('@').first;
    _email = user.email ?? '';
  }

  Future<void> _pickAvatar() async {
    final picked = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () async {
                Navigator.pop(context,
                    await _picker.pickImage(source: ImageSource.camera));
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () async {
                Navigator.pop(context,
                    await _picker.pickImage(source: ImageSource.gallery));
              },
            ),
          ],
        ),
      ),
    );

    if (picked != null) {
      setState(() => _avatarFile = File(picked.path));

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final fileName =
            '${user.uid}_${DateTime.now().millisecondsSinceEpoch}${path.extension(picked.path)}';
        final ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('profile_pics/$fileName');

        await ref.putFile(File(picked.path));
        final downloadURL = await ref.getDownloadURL();

        await user.updatePhotoURL(downloadURL);
        setState(() {}); // refresh avatar
      }
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    // Navigation handled by main.dart StreamBuilder
  }

  @override
  Widget build(BuildContext ctx) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Your Profile'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.redAccent),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 32),
          Center(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[800],
                  backgroundImage: _avatarFile != null
                      ? FileImage(_avatarFile!)
                      : (user?.photoURL != null
                          ? NetworkImage(user!.photoURL!)
                          : const AssetImage('assets/default-avatar.png'))
                      as ImageProvider,
                ),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: kPrimaryGreen,
                  child: IconButton(
                    icon: const Icon(Icons.edit, size: 16, color: Colors.black),
                    onPressed: _pickAvatar,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: _editingUsername
                ? SizedBox(
                    width: 200,
                    child: TextField(
                      autofocus: true,
                      controller: TextEditingController(text: _username),
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'Enter your name',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      onSubmitted: (val) async {
                        if (val.trim().isNotEmpty) {
                          await FirebaseAuth.instance.currentUser!
                              .updateDisplayName(val.trim());
                          setState(() => _username = val.trim());
                        }
                        setState(() => _editingUsername = false);
                      },
                    ),
                  )
                : GestureDetector(
                    onTap: () => setState(() => _editingUsername = true),
                    child: Text(
                      _username,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(_email, style: const TextStyle(color: Colors.grey)),
          ),
          const SizedBox(height: 32),
          const _SectionHeader('Account Settings'),
          _SettingsTile(
            title: 'Change Email',
            icon: Icons.email_outlined,
            onTap: () => Navigator.of(ctx).push(
              MaterialPageRoute(builder: (_) => const ChangeEmailScreen()),
            ),
          ),
          _SettingsTile(
            title: 'Change Password',
            icon: Icons.lock_outline,
            onTap: () => Navigator.of(ctx).push(
              MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext ctx) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      );
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext ctx) => ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: Icon(icon, color: Colors.grey),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      );
}
