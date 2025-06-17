
import 'dart:async';
import 'package:flutter/material.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _textFadeController;
  late final Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();
    _textFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _textFadeAnimation = CurvedAnimation(
      parent: _textFadeController,
      curve: Curves.easeIn,
    );

    _textFadeController.forward();

    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  @override
  void dispose() {
    _textFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.remove_red_eye_outlined,
              size: 120,
              color: kPrimaryGreen,
            ),
            const SizedBox(height: 16),
            FadeTransition(
              opacity: _textFadeAnimation,
              child: Text(
                'I.S.U.',
                style: TextStyle(
                  fontSize: 28,
                  color: kPrimaryGreen,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
