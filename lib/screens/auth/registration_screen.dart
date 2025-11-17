import 'package:flutter/material.dart';
import 'package:myapp/services/auth_service.dart'; // Ensure correct import

import 'package:myapp/models/user_model.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  String errorMessage = '';

  void _register() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    // Basic validation (will add more robust validation later)
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = "Please enter both email and password.";
      });
      return;
    }

    // Clear error message if validation passes initially
    setState(() {
      errorMessage = '';
    });

    try {
      final UserModel? user = await _authService.signUpWithEmailPassword(
        email,
        password,
      );
      if (user != null) {
        // Registration successful, navigate to login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        ); // Correct navigation
      } else {
        // This case might happen if AuthService returns null without throwing,
        // though with refined error handling, exceptions are more likely.
        setState(() {
          errorMessage = 'Registration failed. Please try again.';
        });
      }
    } catch (e) {
      // Registration failed due to an exception (e.g., FirebaseAuthException)
      setState(() {
        errorMessage = e.toString();
      }); // Display the exception message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _register, child: Text('Register')),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
