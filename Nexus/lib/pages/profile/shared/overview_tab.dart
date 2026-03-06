import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../styles/app_theme.dart';
import '../../../providers/profile/profile_provider.dart';

class OverviewTab extends ConsumerWidget {
  const OverviewTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileProvider);
    final activeMembers = state.clubMembers.where((m) => m.status == 'Active').length;
    final pendingTasks = state.pendingTasksCount;
    final unreadNotifs = state.unreadNotificationsCount;

    final stats = [
      _Stat('Active Members', '$activeMembers', Icons.people_rounded, AppTheme.primaryAccent),
      _Stat('Pending Tasks', '$pendingTasks', Icons.check_circle_outline, const Color(0xFFF59E0B)),
      _Stat('Messages', '${state.clubMessages.length}', Icons.message_rounded, const Color(0xFF10B981)),
      _Stat('Notifications', '$unreadNotifs', Icons.notifications_rounded, AppTheme.secondaryAccent),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back, ${state.profile.name.split(' ')[0]}',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                  ),
                  const SizedBox(height: 4),
                  Text("Here's what's happening with your team today.",
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                ],
              ),
            ],
          ).animate().fadeIn(duration: 400.ms),

          const SizedBox(height: 20),

          // Stats grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: stats.map((stat) => _StatCard(stat: stat)).toList(),
          ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.05, end: 0),

          const SizedBox(height: 24),

          // Recent Activity
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassSurface : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassBorder : AppTheme.lightBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Recent Activity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
                const SizedBox(height: 4),
                Text('Latest actions from your team members.', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                const SizedBox(height: 16),
                if (state.notifications.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('No recent activity.', style: TextStyle(color: AppTheme.textSecondary)),
                  )
                else
                  ...state.notifications.take(5).map((n) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 6),
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: AppTheme.accentGradient,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(n.title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface)),
                                  const SizedBox(height: 2),
                                  Text(n.message, style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
              ],
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 200.ms),

          const SizedBox(height: 16),

          // Team Status
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassSurface : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassBorder : AppTheme.lightBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Team Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
                const SizedBox(height: 4),
                Text('Overview of current sprint.', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                const SizedBox(height: 16),
                _TeamStatusItem(icon: Icons.trending_up_rounded, title: 'Sprint Deadline', subtitle: 'Next release in 14 days'),
                const SizedBox(height: 12),
                _TeamStatusItem(icon: Icons.message_rounded, title: 'Daily Standup', subtitle: 'Today at 4:00 PM'),
              ],
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 300.ms),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _Stat {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  const _Stat(this.title, this.value, this.icon, this.color);
}

class _StatCard extends StatelessWidget {
  final _Stat stat;
  const _StatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassSurface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassBorder : AppTheme.lightBorder),
        boxShadow: [
          BoxShadow(color: stat.color.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(stat.title, style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
              ),
              Icon(stat.icon, color: stat.color.withOpacity(0.6), size: 18),
            ],
          ),
          Text(stat.value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
        ],
      ),
    );
  }
}

class _TeamStatusItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _TeamStatusItem({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? AppTheme.backgroundDark.withOpacity(0.5) : AppTheme.lightBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassBorder : AppTheme.lightBorder),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.textSecondary),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface)),
              Text(subtitle, style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}
