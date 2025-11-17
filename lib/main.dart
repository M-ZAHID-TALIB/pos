import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/screens/auth/login_screen.dart';
import 'package:myapp/screens/dashboard/dashboard_screen.dart'; // Ensure correct import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    if (kDebugMode) {
      print("Error initializing Firebase: $e");
    }
    // Handle any initialization errors here
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POS App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
      routes: {
        // Add routes here
        '/dashboard': (context) => DashboardScreen(),
      },
    );
  }
}
