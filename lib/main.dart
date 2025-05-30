import 'package:flutter/material.dart';
import 'package:load_monitoring_mobile_app/Screens/device_screen.dart';
import 'package:load_monitoring_mobile_app/Screens/home.dart';
import 'package:load_monitoring_mobile_app/Screens/reports.dart';
import 'package:load_monitoring_mobile_app/Screens/Settings.dart';
import 'package:load_monitoring_mobile_app/Screens/notifications.dart';
import 'package:load_monitoring_mobile_app/Screens/profile.dart';

// Custom green color
const Color kPrimaryGreen = Colors.greenAccent;

// Profile menu choices
enum _ProfileMenu { changeUsername, changeAvatar, logout }

void main() {
  runApp(const SmartHomeApp());
}

class SmartHomeApp extends StatelessWidget {
  const SmartHomeApp({super.key});

  @override
  Widget build(BuildContext ctx) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Home',
      theme: ThemeData.dark().copyWith(
        primaryColor: kPrimaryGreen,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.grey[900],
          selectedItemColor: kPrimaryGreen,
          unselectedItemColor: Colors.white70,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  // our four screens
  final _screens = const [
    HomeScreen(),
    DeviceScreen(),
    ReportsPage(),
    SettingsScreen(),
  ];

  final _titles = ['Home', 'Devices', 'Reports', 'Settings'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.remove_red_eye_outlined, color: kPrimaryGreen),
            const SizedBox(width: 8),
            Text(
              _titles[_currentIndex],
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          // 1) Notifications button
          IconButton(
            icon: const Icon(Icons.notifications_none, color: kPrimaryGreen),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const NotificationsScreen(),
                ),
              );
            },
          ),

          // 2) Profile dropdown
          PopupMenuButton<_ProfileMenu>(
            icon: const CircleAvatar(
              backgroundColor: kPrimaryGreen,
              child: Icon(Icons.person, color: Colors.black),
            ),
            color: Colors.grey[900],
            itemBuilder: (_) => [
              // Header (disabled)
              const PopupMenuItem(
                enabled: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.person, color:kPrimaryGreen),
                    Text(
                      'Username',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: _ProfileMenu.changeUsername,
                child: Text('Manage Profile',
                    style: TextStyle(color: Colors.white)),
              ),
              // const PopupMenuItem(
              //   value: _ProfileMenu.changeAvatar,
              //   child: Text('Change Password',
              //       style: TextStyle(color: Colors.white)),
              // ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: _ProfileMenu.logout,
                child:
                    Text('Log Out', style: TextStyle(color: Colors.redAccent)),
              ),
            ],
            onSelected: (choice) {
              switch (choice) {
                case _ProfileMenu.changeUsername:
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => ProfileScreen()),
                  );
                  break;
                case _ProfileMenu.changeAvatar:
                 Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => ProfileScreen()),
                  );
                  // push change-avatar screen
                  break;
                case _ProfileMenu.logout:
                  //  perform logout logic
                  break;
              }
            },
          ),

          const SizedBox(width: 8),
        ],
      ),

      // if Home, we want its internal TabBar; other screens handle their own UI
      body: _screens[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Devices'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Reports'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
