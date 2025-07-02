import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:load_monitoring_mobile_app/Screens/device_screen.dart';
import 'package:load_monitoring_mobile_app/Screens/home.dart';
import 'package:load_monitoring_mobile_app/Screens/reports.dart';
import 'package:load_monitoring_mobile_app/Screens/Settings.dart';
import 'package:load_monitoring_mobile_app/Screens/notifications.dart';
import 'package:load_monitoring_mobile_app/Screens/profile.dart';
import 'package:load_monitoring_mobile_app/Screens/login_screen.dart';
import 'package:load_monitoring_mobile_app/Screens/verify_email_screen.dart';
import 'package:load_monitoring_mobile_app/Screens/register_screen.dart';
import 'package:load_monitoring_mobile_app/Screens/splash_screen.dart';

const Color kPrimaryGreen = Color(0xFF00C853); 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SmartHomeApp());
}

class SmartHomeApp extends StatelessWidget {
  const SmartHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ISU App',
      theme: ThemeData.dark().copyWith(
        primaryColor: kPrimaryGreen,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.grey[900],
          selectedItemColor: kPrimaryGreen,
          unselectedItemColor: Colors.white70,
        ),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final user = FirebaseAuth.instance.currentUser!;
            return user.emailVerified ? const MainScreen() : const VerifyEmailScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/verify': (context) => const VerifyEmailScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final username = user.displayName ?? user.email?.split('@')[0] ?? 'User';
    final avatarImage = (user.photoURL != null && user.photoURL!.isNotEmpty)
        ? NetworkImage(user.photoURL!)
        : null;

    final screens = [
      HomeScreen(),
      const DeviceScreen(),
      const ReportsPage(),
      const SettingsScreen(),
    ];
    final titles = ['Home', 'Devices', 'Reports', 'Settings'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.remove_red_eye_outlined, color: kPrimaryGreen),
            const SizedBox(width: 8),
            Text(titles[_currentIndex], style: const TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: kPrimaryGreen),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: CircleAvatar(
              backgroundColor: Colors.black,
              backgroundImage: avatarImage,
              child: avatarImage == null
                  ? const Icon(Icons.person, color: kPrimaryGreen)
                  : null,
            ),
            color: Colors.grey[900],
            itemBuilder: (_) => [
              PopupMenuItem<String>(
                enabled: false,
                child: Row(
                  children: [
                    const Icon(Icons.person, color: kPrimaryGreen),
                    const SizedBox(width: 8),
                    Text(username, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('Manage Profile', style: TextStyle(color: Colors.white)),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Log Out', style: TextStyle(color: Colors.redAccent)),
              ),
            ],
            onSelected: (value) {
              if (value == 'profile') {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              } else if (value == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Devices'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
