import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../styles/app_theme.dart';
import '../../components/ui/glass_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock user data
    const String userName = 'Priyanshu';
    const String userRole = 'SE';
    const String userBranch = 'COMP';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: AnimationLimiter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 600),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                // Header Region
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('My Profile', style: Theme.of(context).textTheme.displayMedium),
                    IconButton(
                      icon: const Icon(Icons.settings_rounded, color: AppTheme.textSecondary),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // User Info Card
                GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Hero(
                        tag: 'profile_avatar',
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: AppTheme.primaryAccent.withOpacity(0.2),
                          child: const Icon(Icons.person_rounded, size: 40, color: AppTheme.primaryAccent),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.secondaryAccent.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppTheme.secondaryAccent.withOpacity(0.5)),
                              ),
                              child: Text(
                                '$userRole - $userBranch',
                                style: const TextStyle(color: AppTheme.secondaryAccent, fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                Text('My Applications', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                
                // Pending Applications
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.access_time_rounded, color: Colors.amber),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('GDG Application', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(height: 4),
                            Text('Status: Under Review', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
                Text('Dashboard Panel', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                
                // Role specific panel placeholder
                GlassCard(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(Icons.space_dashboard_rounded, size: 48, color: AppTheme.textSecondary),
                        const SizedBox(height: 16),
                        Text(
                          '$userRole Control Panel',
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Your role-specific tools and statistics will appear here.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 100), // Padding for bottom nav
              ],
            ),
          ),
        ),
      ),
    );
  }
}
