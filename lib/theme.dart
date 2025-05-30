// lib/theme/app_theme.dart

import 'package:flutter/material.dart';

const Color kPrimaryGreen = Colors.greenAccent;

class AppTheme {
  static ThemeData get dark {
    return ThemeData.dark().copyWith(
      primaryColor: kPrimaryGreen,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.grey[900],
        selectedItemColor: kPrimaryGreen,
        unselectedItemColor: Colors.white70,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: kPrimaryGreen),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
      ),
      iconTheme: const IconThemeData(color: kPrimaryGreen),
    );
  }
}
