import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
      _Stat('Active Members', '$activeMembers', Icons.people_rounded, const Color(0xFF3B82F6), const Color(0xFFEFF6FF)),
      _Stat('Pending Tasks', '$pendingTasks', Icons.check_circle_outline, const Color(0xFFF59E0B), const Color(0xFFFFFBEB)),
      _Stat('Messages', '${state.clubMessages.length}', Icons.message_rounded, const Color(0xFF10B981), const Color(0xFFECFDF5)),
      _Stat('Notifications', '$unreadNotifs', Icons.notifications_rounded, const Color(0xFF8B5CF6), const Color(0xFFF5F3FF)),
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
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                  ),
                  const SizedBox(height: 4),
                  const Text("Here's what's happening with your team today.",
                      style: TextStyle(color: Color(0xFF6B7280), fontSize: 14)),
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Recent Activity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF111827))),
                const SizedBox(height: 4),
                const Text('Latest actions from your team members.', style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                const SizedBox(height: 16),
                if (state.notifications.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No recent activity.', style: TextStyle(color: Color(0xFF6B7280))),
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
                                color: Color(0xFF2563EB),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(n.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF111827))),
                                  const SizedBox(height: 2),
                                  Text(n.message, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Team Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF111827))),
                const SizedBox(height: 4),
                const Text('Overview of current sprint.', style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
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
  final Color bg;
  const _Stat(this.title, this.value, this.icon, this.color, this.bg);
}

class _StatCard extends StatelessWidget {
  final _Stat stat;
  const _StatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2)),
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
                child: Text(stat.title, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12, fontWeight: FontWeight.w500)),
              ),
              Icon(stat.icon, color: const Color(0xFF9CA3AF), size: 18),
            ],
          ),
          Text(stat.value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
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
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF9CA3AF)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF111827))),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
            ],
          ),
        ],
      ),
    );
  }
}
