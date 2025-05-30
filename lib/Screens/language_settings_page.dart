import 'package:flutter/material.dart';

class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Language Settings'),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: const [
          ListTile(
            title: Text('English', style: TextStyle(color: Colors.white)),
            trailing: Icon(Icons.check, color: Colors.green),
          ),
          ListTile(
            title: Text('Spanish', style: TextStyle(color: Colors.white)),
          ),
          ListTile(
            title: Text('French', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
