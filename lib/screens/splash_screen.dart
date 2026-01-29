import 'package:flutter/material.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/screens/auth/login_screen.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/screens/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();

    // Navigate after animation and auth check
    // We wait a bit to show the logo, then let the AuthWrapper handle the rest via the parent widget
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        // Current logic uses AuthWrapper in main.dart, but we want the Splash to be the FIRST screen.
        // Effectively, we can just replace the Splash with the AuthWrapper.
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const AuthWrapper(),
            transitionDuration: const Duration(milliseconds: 800),
            transitionsBuilder:
                (_, a, __, c) => FadeTransition(opacity: a, child: c),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _opacity.value,
              child: Transform.scale(
                scale: _scale.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.point_of_sale_rounded,
                        size: 64,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Pro POS',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Modern Point of Sale',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 48),
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Moved AuthWrapper here or import it?
// Ideally AuthWrapper is a separate widget or in main.dart.
// I will reuse the one in main.dart by importing checking main.dart content effectively.
// But for now, I'll navigate TO the route that holds AuthWrapper.
// In main.dart, 'home' will be SplashScreen. SplashScreen navigates to AuthWrapper.

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    // Smooth transition between states
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child:
          authProvider.isLoading
              ? const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ) // Or a persistent loading state
              : authProvider.isAuthenticated
              ? const DashboardScreen()
              : const LoginScreen(),
    );
  }
}
