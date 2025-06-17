// lib/Screens/reset_password_screen.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main.dart'; // for kPrimaryGreen

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _emailController = TextEditingController();
  String _feedback = '';
  bool _loading = false;

  Future<void> _resetPassword() async {
    setState(() {
      _feedback = '';
      _loading = true;
    });

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      setState(() {
        _feedback = '✅ A password reset link has been sent to your email.';
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _feedback = '❌ Failed to send reset email. ${e.toString()}';
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar:
          AppBar(title: const Text('Reset Password'), backgroundColor: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            const Icon(Icons.lock_reset, size: 100, color: kPrimaryGreen),
            const SizedBox(height: 24),
            const Text(
              'Enter your email, and we’ll send a reset link.',
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _loading ? null : _resetPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryGreen,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text('Send Reset Link',
                      style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(height: 16),
            if (_feedback.isNotEmpty)
              Text(
                _feedback,
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
