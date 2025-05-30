import 'package:flutter/material.dart';

class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newEmailController = TextEditingController();
  String currentEmail = 'user@example.com'; // This should come from user data

  bool _isLoading = false;
  String? _successMessage;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _successMessage = null;
    });

    // Simulated delay and response (replace this with real API call)
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _successMessage =
          'A confirmation email has been sent to ${_newEmailController.text}.';
    });

    // In a real app: Call API to begin email change and trigger verification
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Change Email'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'Current Email: $currentEmail',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _newEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'New Email',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (val) {
                  if (val == null || !val.contains('@')) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Submit'),
                  ),
            const SizedBox(height: 16),
            if (_successMessage != null)
              Text(
                _successMessage!,
                style: const TextStyle(color: Colors.greenAccent),
              ),
          ],
        ),
      ),
    );
  }
}
