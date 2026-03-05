import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/profile/profile_provider.dart';
import 'overview_tab.dart';
import 'members_tab.dart';
import 'tasks_tab.dart';
import 'messages_tab.dart';
import 'profile_tab.dart';

class DashboardLayout extends ConsumerWidget {
  const DashboardLayout({super.key});

  static const _tabs = [
    ('Overview', Icons.dashboard_rounded),
    ('Members', Icons.people_rounded),
    ('Tasks', Icons.check_circle_outline_rounded),
    ('Messages', Icons.message_rounded),
    ('Profile', Icons.person_rounded),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final notifier = ref.read(profileProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      drawer: _buildSidebar(context, ref, profileState, notifier),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF111827)),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Row(
          children: [
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
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
            const Text('Dashboard', style: TextStyle(color: Color(0xFF111827), fontWeight: FontWeight.w600, fontSize: 16)),
          ],
        ),
      ),
      body: Stack(
        children: [
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
            child: _buildBottomNav(profileState, notifier),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(ProfileState profileState, ProfileNotifier notifier) {
    return Container(
      height: 66,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _tabs.map((tab) {
              final tabId = tab.$1.toLowerCase();
              final isSelected = profileState.activeTab == tabId;
              return _buildNavItem(tab.$2, tab.$1, tabId, isSelected, notifier);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, String tabId, bool isSelected, ProfileNotifier notifier) {
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
          color: isSelected
              ? const Color(0xFFEFF6FF)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF9CA3AF),
              size: 20,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF2563EB),
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
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
      case 'profile':
        return const ProfileTab(key: ValueKey('profile'));
      default:
        return const OverviewTab(key: ValueKey('overview'));
    }
  }

  Widget _buildSidebar(BuildContext context, WidgetRef ref, ProfileState pState, ProfileNotifier notifier) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF111827),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        pState.role,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${pState.role} Panel', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF111827))),
                      const Text('Workspace', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                    ],
                  ),
                ],
              ),
            ),

            // Club switcher
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('SWITCH CLUB', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF9CA3AF), letterSpacing: 1.2)),
                  const SizedBox(height: 8),
                  Row(
                    children: pState.profile.clubs.map((club) {
                      final isActive = pState.activeClub?.id == club.id;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => notifier.switchClub(club.id),
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isActive ? const Color(0xFF2563EB) : const Color(0xFFE5E7EB),
                                width: 2,
                              ),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                club.name.split(' ').last.substring(0, 1),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: isActive ? const Color(0xFF2563EB) : const Color(0xFF6B7280),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  Text(pState.activeClub?.name ?? '', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF111827))),
                  Text(pState.activeClub?.role ?? '', style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Divider(color: Color(0xFFE5E7EB)),

            // Nav items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                children: _tabs.where((t) => t.$1 != 'Profile').map((tab) {
                  final tabId = tab.$1.toLowerCase();
                  final isSelected = pState.activeTab == tabId;
                  return ListTile(
                    leading: Icon(
                      tab.$2,
                      size: 20,
                      color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF9CA3AF),
                    ),
                    title: Text(
                      tab.$1,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? const Color(0xFF1D4ED8) : const Color(0xFF4B5563),
                      ),
                    ),
                    selected: isSelected,
                    selectedTileColor: const Color(0xFFEFF6FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onTap: () {
                      notifier.setActiveTab(tabId);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),

            // User profile at bottom
            const Divider(color: Color(0xFFE5E7EB)),
            ListTile(
              leading: CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFFEFF6FF),
                child: Text(
                  pState.profile.name.isNotEmpty ? pState.profile.name[0] : '?',
                  style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(pState.profile.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF111827))),
              subtitle: Text(pState.profile.email, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
              onTap: () {
                notifier.setActiveTab('profile');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, size: 18, color: Color(0xFFDC2626)),
              title: const Text('Sign Out', style: TextStyle(fontSize: 13, color: Color(0xFFDC2626))),
              onTap: () {
                Navigator.pop(context); // close drawer
                GoRouter.of(context).go('/home');
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
