import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile.dart';
import 'language_settings_page.dart';
import 'notification_settings_page.dart';
import 'theme_settings_page.dart';

const Color kPrimaryGreen = Colors.greenAccent;

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        children: [
          _SectionHeader('Account'),
          _SettingsTile(
            title: 'Manage Profile',
            icon: Icons.arrow_forward,
            onTap: () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
          const SizedBox(height: 24),
          _SectionHeader('App Preferences'),
          _SettingsTile(
            title: 'Theme',
            icon: Icons.arrow_forward,
            onTap: () => Navigator.push(
                ctx,
                MaterialPageRoute(
                    builder: (_) => const ThemeSettingsPage())),
          ),
          _SettingsTile(
            title: 'Language',
            icon: Icons.arrow_forward,
            onTap: () => Navigator.push(
                ctx,
                MaterialPageRoute(
                    builder: (_) => const LanguageSettingsPage())),
          ),
          _SettingsTile(
            title: 'Notification Settings',
            icon: Icons.arrow_forward,
            onTap: () => Navigator.push(
                ctx,
                MaterialPageRoute(
                    builder: (_) => const NotificationSettingsPage())),
          ),
          const SizedBox(height: 24),
          _SectionHeader('Support'),
          _SettingsTile(
            title: 'Help Center',
            icon: Icons.help_outline,
            onTap: () {
              // TODO: Navigate to Help Center
            },
          ),
          _SettingsTile(
            title: 'Contact Us',
            icon: Icons.mail_outline,
            onTap: () {
              // TODO: Navigate to Contact Us
            },
          ),
          const SizedBox(height: 32),
          // Logout button, styled
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (ctx.mounted) {
                  Navigator.of(ctx).pushReplacementNamed('/login');
                }
              },
              icon: const Icon(Icons.logout, color: Colors.black),
              label: const Text('Logout',
                  style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: Icon(icon, color: Colors.grey),
        onTap: onTap,
      );
}
