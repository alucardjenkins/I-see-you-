import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  late final User? user;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    isEmailVerified = user?.emailVerified ?? false;

    if (!isEmailVerified) {
      sendVerificationEmail();

      // Periodically check if the user verified their email
      _timer = Timer.periodic(const Duration(seconds: 5), (_) => checkEmailVerified());
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      await user?.sendEmailVerification();
      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending email: $e')),
      );
    }
  }

  Future<void> checkEmailVerified() async {
    await user?.reload();
    setState(() => isEmailVerified = user!.emailVerified);

    if (isEmailVerified) {
      _timer.cancel();
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Verify Email'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Icon(Icons.email_outlined,
                  size: 100, color: Colors.greenAccent),
              const SizedBox(height: 32),
              const Text(
                'A verification email has been sent to your email.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: canResendEmail ? sendVerificationEmail : null,
                icon: const Icon(Icons.refresh, color: Colors.black),
                label: const Text('Resend Email'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => FirebaseAuth.instance.signOut(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
        ),
      );
}
