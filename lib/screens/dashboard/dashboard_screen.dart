import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../constants/app_colors.dart';
import 'package:myapp/screens/products/product_list_screen.dart';
import 'package:myapp/screens/reports/reports_screen.dart';
import 'package:myapp/screens/auth/registration_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('User not found')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => authProvider.logout(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(user.email, user.role),
            const SizedBox(height: 32),
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children:
                  user.role == 'admin'
                      ? _buildAdminActions(context)
                      : _buildStaffActions(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String email, String role) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withAlpha(50),
            radius: 30,
            child: const Icon(Icons.person, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  email,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  role.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white.withAlpha(200),
                    fontSize: 12,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAdminActions(BuildContext context) {
    return [
      _actionCard(
        context,
        'Products',
        Icons.inventory_2_outlined,
        AppColors.primary,
        () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ProductListScreen(isPOSMode: false),
          ),
        ),
      ),
      _actionCard(
        context,
        'Reports',
        Icons.analytics_outlined,
        AppColors.accent,
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ReportsScreen()),
        ),
      ),
      _actionCard(
        context,
        'Add Staff',
        Icons.person_add_outlined,
        AppColors.warning,
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RegistrationScreen()),
        ),
      ),
      _actionCard(
        context,
        'Settings',
        Icons.settings_outlined,
        AppColors.textSecondary,
        () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Settings not implemented yet")),
          );
        },
      ),
    ];
  }

  List<Widget> _buildStaffActions(BuildContext context) {
    return [
      _actionCard(
        context,
        'New Sale',
        Icons.add_shopping_cart_rounded,
        AppColors.accent,
        () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ProductListScreen(isPOSMode: true),
          ),
        ),
      ),
      _actionCard(
        context,
        'History',
        Icons.history_rounded,
        AppColors.primary,
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ReportsScreen()),
        ),
      ),
      _actionCard(
        context,
        'Inventory',
        Icons.list_alt_rounded,
        AppColors.warning,
        () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ProductListScreen(isPOSMode: false),
          ),
        ),
      ),
      _actionCard(
        context,
        'Profile',
        Icons.person_outline,
        AppColors.textSecondary,
        () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile not implemented yet")),
          );
        },
      ),
    ];
  }

  Widget _actionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      color: AppColors.surface,
      elevation: 2,
      shadowColor: Colors.black.withAlpha(25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
