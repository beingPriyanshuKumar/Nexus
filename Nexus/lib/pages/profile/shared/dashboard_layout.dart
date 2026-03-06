import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../styles/app_theme.dart';
import '../../../providers/profile/profile_provider.dart';
import 'overview_tab.dart';
import 'members_tab.dart';
import 'tasks_tab.dart';
import 'messages_tab.dart';
import 'profile_tab.dart';
import 'explore_clubs_tab.dart';

class DashboardLayout extends ConsumerWidget {
  const DashboardLayout({super.key});

  List<(String, IconData)> _getTabs(String role) {
    final tabs = <(String, IconData)>[
      ('Overview', Icons.dashboard_rounded),
      ('Members', Icons.people_rounded),
      ('Tasks', Icons.check_circle_outline_rounded),
      ('Messages', Icons.message_rounded),
    ];
    // Add Explore tab for FE role
    if (role == 'FE') {
      tabs.add(('Explore', Icons.explore_rounded));
    }
    tabs.add(('Profile', Icons.person_rounded));
    return tabs;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final notifier = ref.read(profileProvider.notifier);
    final tabs = _getTabs(profileState.role);

    return Theme(
      data: AppTheme.lightTheme,
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
            title: Row(
              children: [
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    gradient: AppTheme.accentGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      profileState.role,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text('Dashboard', style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w600, fontSize: 16)),
              ],
            ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(
            height: 2,
            decoration: const BoxDecoration(gradient: AppTheme.accentGradient),
          ),
        ),
      ),
            body: Stack(
              children: [
                // Clean background
                Container(
                  color: theme.scaffoldBackgroundColor,
                ),

          // Tab content
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildContent(profileState.activeTab),
            ),
          ),

                // Floating Bottom Navigation
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: _buildBottomNav(context, profileState, notifier, tabs),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, ProfileState profileState, ProfileNotifier notifier, List<(String, IconData)> tabs) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 66,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.glassSurface : Colors.white,
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: isDark ? AppTheme.glassBorder : AppTheme.lightBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.05),
            blurRadius: 15,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: tabs.map((tab) {
              final tabId = tab.$1.toLowerCase();
              final isSelected = profileState.activeTab == tabId;
              return _buildNavItem(context, tab.$2, tab.$1, tabId, isSelected, notifier);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, String tabId, bool isSelected, ProfileNotifier notifier) {
    return GestureDetector(
      onTap: () => notifier.setActiveTab(tabId),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuint,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 14 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppTheme.primaryAccent.withOpacity(0.2),
                    AppTheme.secondaryAccent.withOpacity(0.1),
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShaderMask(
              shaderCallback: (bounds) {
                if (isSelected) {
                  return AppTheme.accentGradient.createShader(bounds);
                }
                return LinearGradient(
                  colors: [Theme.of(context).textTheme.bodyMedium!.color!, Theme.of(context).textTheme.bodyMedium!.color!],
                ).createShader(bounds);
              },
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              ShaderMask(
                shaderCallback: (bounds) =>
                    AppTheme.accentGradient.createShader(bounds),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContent(String activeTab) {
    switch (activeTab) {
      case 'overview':
        return const OverviewTab(key: ValueKey('overview'));
      case 'members':
        return const MembersTab(key: ValueKey('members'));
      case 'tasks':
        return const TasksTab(key: ValueKey('tasks'));
      case 'messages':
        return const MessagesTab(key: ValueKey('messages'));
      case 'explore':
        return const ExploreClubsTab(key: ValueKey('explore'));
      case 'profile':
        return const ProfileTab(key: ValueKey('profile'));
      default:
        return const OverviewTab(key: ValueKey('overview'));
    }
  }
}
