import 'package:flutter/material.dart';
import 'package:myapp/screens/dashboard/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
// your main screen
import 'registration_screen.dart';
//import '../dashboard_screen.dart'; // Add this import for DashboardScreen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String errorMessage = '';

  void _login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? savedEmail = prefs.getString("saved_email");
    String? savedPass = prefs.getString("saved_password");

    final enteredEmail = _emailController.text.trim();
    final enteredPassword = _passwordController.text.trim();

    if (enteredEmail.isEmpty || enteredPassword.isEmpty) {
      setState(() {
        errorMessage = "Please enter both email and password.";
      });
      return;
    }

    if (enteredEmail == savedEmail && enteredPassword == savedPass) {
      // Login success
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    } else {
      setState(() {
        errorMessage = "Invalid email or password.";
      });
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
            if (errorMessage.isNotEmpty)
              Text(errorMessage, style: TextStyle(color: Colors.red)),
            SizedBox(height: 20),

            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),

            ElevatedButton(onPressed: _login, child: Text('Login')),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationScreen()),
                );
              },
              child: Text("Create Account"),
            ),
          ],
        ),
      ),
    );
  }
}
