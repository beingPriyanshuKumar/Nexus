import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../styles/app_theme.dart';
import '../../../../utils/models/club_model.dart';
import 'package:go_router/go_router.dart';

// Mock data matching the web's clubs.json structure
final List<ClubModel> mockClubs = [
  ClubModel(
    abbr: 'OSS',
    name: 'OSS Club',
    fullForm: 'Open Source Software Club',
    desc: 'Encouraging students to contribute to open source projects and learn collaborative software development.',
    focusAreas: ['Open source contribution workflows', 'Contribution (Git/Github)'],
    activities: ['INNERVE', 'FSOC', 'Graphica', 'Spark', 'Internal SIH', 'Replica'],
    keywords: ['Open Source', 'Git', 'OSS', 'Collaboration'],
  ),
  ClubModel(
    abbr: 'GDG',
    name: 'GDG AIT Pune',
    fullForm: 'Google Developer Group',
    desc: 'Community-driven developer group focused on practical developer skills and technology learning.',
    focusAreas: ['Web & mobile development', 'Cloud and architecture', 'Developer tooling'],
    activities: ['Frontend Jams', 'Backend Jams', 'FSOC', 'Enliven', 'Google Cloud Workshop'],
    keywords: ['Google', 'Flutter', 'Cloud', 'Web Dev'],
  ),
  ClubModel(
    abbr: 'CP',
    name: 'CP Club',
    fullForm: 'Competitive Programming',
    desc: 'Sharpen your problem-solving skills with competitive coding and algorithm challenges.',
    focusAreas: ['Data Structures', 'Algorithms', 'Competitive Coding'],
    activities: ['Weekly Contests', 'Codeforces Practice', 'Internal Hackathons'],
    keywords: ['DSA', 'Codeforces', 'LeetCode', 'CP'],
  ),
  ClubModel(
    abbr: 'PR',
    name: 'PR Cell',
    fullForm: 'Public Relations Cell',
    desc: 'Managing public relations, media outreach, and brand representation for college events.',
    focusAreas: ['Media Relations', 'Content Creation', 'Event Promotion'],
    activities: ['Newsletter', 'Social Media Management', 'Press Coverage'],
    keywords: ['PR', 'Media', 'Content', 'Outreach'],
  ),
  ClubModel(
    abbr: 'NSS',
    name: 'NSS',
    fullForm: 'National Service Scheme',
    desc: 'Community service and social initiatives for a better tomorrow.',
    focusAreas: ['Community Service', 'Social Awareness', 'Environmental Activities'],
    activities: ['Blood Donation Camps', 'Tree Plantation', 'Village Adoption'],
    keywords: ['Service', 'Community', 'Social'],
  ),
  ClubModel(
    abbr: 'EC',
    name: 'E Cell',
    fullForm: 'Entrepreneurship Cell',
    desc: 'Fostering entrepreneurial spirit and startup culture among students.',
    focusAreas: ['Startup Mentorship', 'Business Development', 'Innovation'],
    activities: ['Startup Weekend', 'Pitch Competitions', 'Speaker Sessions'],
    keywords: ['Startup', 'Business', 'Innovation', 'Entrepreneurship'],
  ),
];

class ClubsListScreen extends StatelessWidget {
  const ClubsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            'Explore',
            style: Theme.of(context).textTheme.displayMedium,
          ).animate().fadeIn(duration: 400.ms),
          Row(
            children: [
              Text(
                'Clubs',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                '.',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.redAccent,
                    ),
              ),
            ],
          ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
          const SizedBox(height: 8),
          Text(
            'Discover communities and apply today.',
            style: Theme.of(context).textTheme.bodyMedium,
          ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
          const SizedBox(height: 24),
          Expanded(
            child: AnimationLimiter(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: mockClubs.length,
                padding: const EdgeInsets.only(bottom: 100),
                itemBuilder: (context, index) {
                  final club = mockClubs[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: _ClubDetailCard(club: club),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClubDetailCard extends StatelessWidget {
  final ClubModel club;

  const _ClubDetailCard({required this.club});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.glassSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.glassBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryAccent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        _getClubIcon(club.abbr),
                        color: AppTheme.primaryAccent,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            club.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (club.fullForm != null)
                            Text(
                              '(${club.fullForm})',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Description
                if (club.desc != null)
                  Text(
                    club.desc!,
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),

                // Keywords
                if (club.keywords.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: club.keywords.map((k) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: AppTheme.primaryAccent.withOpacity(0.3)),
                        ),
                        child: Text(
                          k,
                          style: TextStyle(
                            color: AppTheme.primaryAccent,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],

                // Focus & Activities
                if (club.focusAreas.isNotEmpty ||
                    club.activities.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (club.focusAreas.isNotEmpty)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Focus',
                                  style: TextStyle(
                                      color: AppTheme.primaryAccent,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              ...club.focusAreas.take(3).map((f) => Padding(
                                    padding: const EdgeInsets.only(bottom: 3),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('• ',
                                            style: TextStyle(
                                                color:
                                                    AppTheme.textSecondary,
                                                fontSize: 12)),
                                        Expanded(
                                          child: Text(f,
                                              style: TextStyle(
                                                  color:
                                                      AppTheme.textSecondary,
                                                  fontSize: 12)),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      if (club.activities.isNotEmpty)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Activities',
                                  style: TextStyle(
                                      color: AppTheme.primaryAccent,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              ...club.activities.take(3).map((a) => Padding(
                                    padding: const EdgeInsets.only(bottom: 3),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('• ',
                                            style: TextStyle(
                                                color:
                                                    AppTheme.textSecondary,
                                                fontSize: 12)),
                                        Expanded(
                                          child: Text(a,
                                              style: TextStyle(
                                                  color:
                                                      AppTheme.textSecondary,
                                                  fontSize: 12)),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],

                const SizedBox(height: 18),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.push('/home/clubs/apply', extra: club);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Apply Now',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _showKnowMore(context, club);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(color: AppTheme.glassBorder),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Know More',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showKnowMore(BuildContext context, ClubModel club) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: AppTheme.backgroundLightGradient,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.glassBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryAccent.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            _getClubIcon(club.abbr),
                            color: AppTheme.primaryAccent,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(club.name,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              if (club.fullForm != null)
                                Text(club.fullForm!,
                                    style: TextStyle(
                                        color: AppTheme.textSecondary,
                                        fontSize: 14)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (club.desc != null)
                      Text(club.desc!,
                          style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 14,
                              height: 1.6)),
                    const SizedBox(height: 20),
                    if (club.focusAreas.isNotEmpty) ...[
                      const Text('Focus Areas',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...club.focusAreas.map((f) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(children: [
                              const Text('• ',
                                  style: TextStyle(color: AppTheme.primaryAccent)),
                              Expanded(
                                  child: Text(f,
                                      style: TextStyle(
                                          color: AppTheme.textSecondary,
                                          fontSize: 13))),
                            ]),
                          )),
                    ],
                    if (club.activities.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Text('Activities',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...club.activities.map((a) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(children: [
                              const Text('• ',
                                  style: TextStyle(color: AppTheme.primaryAccent)),
                              Expanded(
                                  child: Text(a,
                                      style: TextStyle(
                                          color: AppTheme.textSecondary,
                                          fontSize: 13))),
                            ]),
                          )),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          context.push('/home/clubs/apply', extra: club);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text('Apply to ${club.name}',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static IconData _getClubIcon(String abbr) {
    switch (abbr.toUpperCase()) {
      case 'GDG':
        return Icons.code_rounded;
      case 'OSS':
        return Icons.integration_instructions_rounded;
      case 'CP':
        return Icons.terminal_rounded;
      case 'PR':
        return Icons.campaign_rounded;
      case 'NSS':
        return Icons.volunteer_activism_rounded;
      case 'EC':
        return Icons.rocket_launch_rounded;
      default:
        return Icons.groups_rounded;
    }
  }
}
