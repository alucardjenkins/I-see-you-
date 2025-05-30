import 'package:flutter/material.dart';

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Theme Settings'),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: const [
          RadioListTile(
            title: Text('System Default', style: TextStyle(color: Colors.white)),
            value: 'system',
            groupValue: 'system',
            onChanged: null,
          ),
          RadioListTile(
            title: Text('Light Mode', style: TextStyle(color: Colors.white)),
            value: 'light',
            groupValue: 'system',
            onChanged: null,
          ),
          RadioListTile(
            title: Text('Dark Mode', style: TextStyle(color: Colors.white)),
            value: 'dark',
            groupValue: 'system',
            onChanged: null,
          ),
        ],
      ),
    );
  }
}
