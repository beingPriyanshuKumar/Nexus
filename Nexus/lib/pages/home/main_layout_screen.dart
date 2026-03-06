import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../styles/app_theme.dart';
import 'home_screen.dart';

class MainLayoutScreen extends StatelessWidget {
  const MainLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: AppTheme.backgroundGradient,
            ),
          ),

          const SafeArea(
            child: HomeScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.backgroundDark,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo with glow
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryAccent.withOpacity(0.2),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: ShaderMask(
                      shaderCallback: (bounds) =>
                          AppTheme.accentGradient.createShader(bounds),
                      child: const Icon(Icons.sync_rounded,
                          size: 48, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'SYNC AIT',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your campus, connected.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            // Gradient divider
            Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                gradient: AppTheme.accentGradient,
                borderRadius: BorderRadius.circular(1),
              ),
            ),

            const SizedBox(height: 8),

            // Menu items
            _DrawerItem(
              icon: Icons.home_rounded,
              label: 'Home',
              isSelected: true,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _DrawerItem(
              icon: Icons.group_rounded,
              label: 'Clubs',
              isSelected: false,
              onTap: () {
                Navigator.pop(context);
                context.push('/home/clubs');
              },
            ),
            _DrawerItem(
              icon: Icons.login_rounded,
              label: 'Login',
              isSelected: false,
              onTap: () {
                Navigator.pop(context);
                context.push('/login');
              },
            ),

            const Spacer(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: isSelected
            ? LinearGradient(
                colors: [
                  AppTheme.primaryAccent.withOpacity(0.15),
                  AppTheme.secondaryAccent.withOpacity(0.05),
                ],
              )
            : null,
      ),
      child: ListTile(
        leading: isSelected
            ? ShaderMask(
                shaderCallback: (bounds) =>
                    AppTheme.accentGradient.createShader(bounds),
                child: Icon(icon, color: Colors.white, size: 22),
              )
            : Icon(icon, color: AppTheme.textSecondary, size: 22),
        title: Text(label,
            style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
