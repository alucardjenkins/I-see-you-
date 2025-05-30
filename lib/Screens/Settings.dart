
import 'package:flutter/material.dart';
import 'package:load_monitoring_mobile_app/Screens/language_settings_page.dart';
import 'package:load_monitoring_mobile_app/Screens/notification_settings_page.dart';
import 'package:load_monitoring_mobile_app/Screens/theme_settings_page.dart';
import 'profile.dart';

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
        children: [
          const SizedBox(height: 32),

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
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
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
