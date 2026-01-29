import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:myapp/screens/dashboard/dashboard_screen.dart';
import 'package:myapp/screens/splash_screen.dart'; // Import Splash
import 'package:myapp/services/cart_service.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/theme/app_theme.dart';
import 'constants/app_colors.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isFirebaseInitialized = false;
  String? initError;

  try {
    // Check if we are on Web, where explicit options are required.
    // We try to use the imported DefaultFirebaseOptions, but if that fails or is invalid,
    // we fallback to a safe dummy config so the app launches (and then shows our error screen).
    FirebaseOptions? options;
    try {
      options = DefaultFirebaseOptions.currentPlatform;
    } catch (_) {
      // Ignore error if DefaultFirebaseOptions is not configured
    }

    if (options == null && kIsWeb) {
      // Provide dummy options to prevent "options != null" assertion crash
      options = const FirebaseOptions(
        apiKey: "dummy-key",
        appId: "dummy-id",
        messagingSenderId: "dummy-sender",
        projectId: "dummy-project",
        measurementId: "dummy-measurement",
      );
    }

    if (options != null) {
      await Firebase.initializeApp(options: options);
    } else {
      await Firebase.initializeApp();
    }

    isFirebaseInitialized = true;
  } catch (e) {
    initError = e.toString();
    debugPrint("Firebase init error: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(isInitialized: isFirebaseInitialized),
        ),
        ChangeNotifierProvider(create: (_) => CartService()),
      ],
      child: MyApp(initError: initError),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String? initError;
  const MyApp({super.key, this.initError});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pro POS',
      theme: AppTheme.lightTheme,
      home:
          initError != null
              ? ConfigErrorScreen(error: initError!)
              : const SplashScreen(), // Start with Splash
    );
  }
}

class ConfigErrorScreen extends StatelessWidget {
  final String error;
  const ConfigErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                size: 64,
                color: AppColors.danger,
              ),
              const SizedBox(height: 24),
              const Text(
                'Connection Failed',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'The app could not connect to the database. This usually means the project is missing its configuration.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Developer Action Required:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Run this command in your terminal:',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'flutterfire configure',
                        style: TextStyle(fontFamily: 'monospace'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
