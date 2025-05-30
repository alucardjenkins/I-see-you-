import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:load_monitoring_mobile_app/Screens/change_email.dart';
import 'change_password_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _avatarFile;
  String _username = 'UserName';
  bool _editingUsername = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAvatar() async {
    final picked = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(children: [
          ListTile(
            leading: const Icon(Icons.photo_camera),
            title: const Text('Camera'),
            onTap: () async {
              Navigator.pop(
                  context,
                  await _picker.pickImage(source: ImageSource.camera));
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Gallery'),
            onTap: () async {
              Navigator.pop(
                  context,
                  await _picker.pickImage(source: ImageSource.gallery));
            },
          ),
        ]),
      ),
    );
    if (picked != null) setState(() => _avatarFile = File(picked.path));
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Your Profile'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 24),
          Center(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.grey[800],
                  backgroundImage: _avatarFile != null
                      ? FileImage(_avatarFile!)
                      : const NetworkImage(
                              'https://example.com/default-avatar.png')
                          as ImageProvider,
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.greenAccent),
                  onPressed: _pickAvatar,
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
                      autofocus: true,
                      controller: TextEditingController(text: _username),
                      style:
                          const TextStyle(color: Colors.white, fontSize: 20),
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'Enter your name',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      onSubmitted: (val) {
                        setState(() {
                          if (val.trim().isNotEmpty) _username = val.trim();
                          _editingUsername = false;
                        });
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
          const Center(
            child: Text('user@example.com',
                style: TextStyle(color: Colors.grey)),
          ),
          const SizedBox(height: 32),

          // Detailed account settings
          _SectionHeader('Account Settings'),
          
          _SettingsTile(
            title: 'Change email',
            icon: Icons.arrow_forward,
            onTap: () => Navigator.push(
                ctx,
                MaterialPageRoute(
                    builder: (_) => const ChangeEmailScreen())),
          ),
            _SettingsTile(
            title: 'Change Password',
            icon: Icons.arrow_forward,
            onTap: () => Navigator.push(
                ctx,
                MaterialPageRoute(
                    builder: (_) => const ChangePasswordPage())),
          ),



          const SizedBox(height: 24),
         
          _SettingsTile(
          title: 'Logout',
          icon: Icons.logout,
          onTap: () {
    // TODO: Implement logout logic (maybe clear auth and navigate to login)
           },
),


          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext ctx) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(text.toUpperCase(),
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _SettingsTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: Icon(icon, color: Colors.grey),
      onTap: onTap,
    );
  }
}
