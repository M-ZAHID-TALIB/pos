import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:myapp/services/auth_service.dart';

class DashboardScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: FutureBuilder(
        future: _authService.getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(child: Text('User not found.'));
          }

          final user = snapshot.data;
          if (user == null) {
            return Center(child: Text('Please log in.'));
          }

          // Role-based Navigation
          if (user.role == 'admin') {
            return AdminDashboard();
          } else {
            return StaffDashboard();
          }
        },
      ),
    );
  }
}

extension on User {
  get role => null;
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Admin Dashboard: Access to Reports and Products'),
    );
  }
}

class StaffDashboard extends StatelessWidget {
  const StaffDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Staff Dashboard: Access to Cart and Checkout'));
  }
}
