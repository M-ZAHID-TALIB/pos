// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:myapp/screens/dashboard/dashboard_screen.dart';
import 'package:myapp/screens/products/product_list_screen.dart';
// ignore: unused_import
import 'package:myapp/models/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  String errorMessage = '';

  _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = "Please enter both email and password.";
      });
      return;
    }

    try {
      final user = await _authService.signInWithEmailPassword(email, password);

      if (user != null) {
        if (user.role == 'admin') {
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (context) => ProductListScreen()),
          );
        } else if (user.role == 'staff') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen()),
          );
        }
      } else {
        // This case might be reached if the service returns null without throwing an exception
        // depending on the AuthService implementation.
        setState(() {
          errorMessage = "Login failed. Please try again.";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage =
            e.toString(); // Display the error message from AuthService
      });
    }
  }

  _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your email to reset password.')),
      );
      return;
    }

    try {
      await _authService.sendPasswordResetEmail(email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset email sent to $email')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send password reset email: ${e.toString()}'),
        ), // Display the error message from AuthService
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your existing TextFields and other widgets
            if (errorMessage.isNotEmpty)
              Text(errorMessage, style: TextStyle(color: Colors.red)),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: Text('Login')),
            TextButton(
              onPressed: _resetPassword,
              child: Text('Forgot Password?'),
            ),
            // Add the TextField widgets here as they seem to be missing from the provided code snippet
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
