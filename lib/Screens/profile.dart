import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'change_email.dart';
import 'change_password_page.dart';
import '../main.dart'; // for kPrimaryGreen

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _avatarFile;
  bool _editingUsername = false;
  late final TextEditingController _usernameController;
  late final String _email;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser!;
    _usernameController = TextEditingController(text: user.displayName ?? user.email!.split('@').first);
    _email = user.email ?? '';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final user = FirebaseAuth.instance.currentUser!;
      final fileName = '${user.uid}_${DateTime.now().millisecondsSinceEpoch}${path.extension(pickedFile.path)}';
      final ref = FirebaseStorage.instance.ref().child('profile_pics/$fileName');
      await ref.putFile(File(pickedFile.path));
      final downloadUrl = await ref.getDownloadURL();
      await user.updatePhotoURL(downloadUrl);
      await user.reload();
      setState(() {
        _avatarFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateDisplayName(String name) async {
    final user = FirebaseAuth.instance.currentUser!;
    await user.updateDisplayName(name);
    await user.reload();
    setState(() => _editingUsername = false);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final avatarProvider = _avatarFile != null
        ? FileImage(_avatarFile!)
        : (user.photoURL != null && user.photoURL!.isNotEmpty
            ? NetworkImage(user.photoURL!)
            : null);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Your Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () => FirebaseAuth.instance.signOut(),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[800],
                  backgroundImage: avatarProvider as ImageProvider<Object>?,
                child: avatarProvider == null
                      ? const Icon(Icons.person, size: 50, color: kPrimaryGreen)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: kPrimaryGreen,
                    child: IconButton(
                      icon: const Icon(Icons.edit, size: 16, color: Colors.black),
                      onPressed: _pickAvatar,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: _editingUsername
                ? SizedBox(
                    width: 200,
                    child: TextField(
                      controller: _usernameController,
                      autofocus: true,
                      onSubmitted: (val) {
                        if (val.trim().isNotEmpty) {
                          _updateDisplayName(val.trim());
                        }
                      },
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'Enter your name',
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () => setState(() => _editingUsername = true),
                    child: Text(
                      _usernameController.text,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
          ),
          const SizedBox(height: 8),
          Center(child: Text(_email, style: const TextStyle(color: Colors.grey))),
          const SizedBox(height: 24),
          ListTile(
            title: const Text('Change Email', style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.email, color: Colors.grey),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ChangeEmailScreen())),
          ),
          ListTile(
            title: const Text('Change Password', style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.lock, color: Colors.grey),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ChangePasswordPage())),
          ),
        ],
      ),
    );
  }
}
