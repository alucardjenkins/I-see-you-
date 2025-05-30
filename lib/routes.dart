import 'package:flutter/material.dart';
import 'package:load_monitoring_mobile_app/main.dart';
import 'package:load_monitoring_mobile_app/screens/change_password_page.dart';
import 'Screens/home.dart';
import 'Screens/device_screen.dart';
import 'Screens/reports.dart';
import 'Screens/Settings.dart';
import 'Screens/notifications.dart';
import 'Screens/profile.dart';
import 'Screens/change_email.dart';
import 'Screens/notification_settings_page.dart';
import 'Screens/theme_settings_page.dart';
import 'Screens/language_settings_page.dart';

/// A map of all named routes in your app.
final Map<String, WidgetBuilder> appRoutes = {
  '/': (_) => const MainScreen(),  
  '/home': (_) => const HomeScreen(),
  '/devices': (_) => const DeviceScreen(),
  '/reports': (_) => const ReportsPage(),
  '/settings': (_) => const SettingsScreen(),
  '/notifications': (_) => const NotificationsScreen(),
  '/profile': (_) => const ProfileScreen(),
  '/change-password': (_) => const ChangePasswordPage(),
  '/change-email': (_) => const ChangeEmailScreen(),
  '/notification-settings': (_) => const NotificationSettingsPage(),
  '/theme-settings': (_) => const ThemeSettingsPage(),
  '/language-settings': (_) => const LanguageSettingsPage(),
};

