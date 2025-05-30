import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Notification Settings'),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: const [
          SwitchListTile(
            title: Text('Push Notifications', style: TextStyle(color: Colors.white)),
            value: true,
            onChanged: null, // Implement state later
          ),
          SwitchListTile(
            title: Text('Email Alerts', style: TextStyle(color: Colors.white)),
            value: false,
            onChanged: null,
          ),
          SwitchListTile(
            title: Text('Vibration', style: TextStyle(color: Colors.white)),
            value: true,
            onChanged: null,
          ),
        ],
      ),
    );
  }
}
