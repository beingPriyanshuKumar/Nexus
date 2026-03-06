import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../styles/app_theme.dart';
import '../utils/models/club_model.dart';

import 'package:flutter_svg/flutter_svg.dart';

class ClubDetailCard extends StatelessWidget {
  final ClubModel club;

  const ClubDetailCard({super.key, required this.club});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left gradient accent bar
          Container(
            width: 4,
            height: 200,
            margin: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              gradient: AppTheme.accentGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          // Card
          Expanded(
            child: Container(
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
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: club.img != null && club.img!.endsWith('.svg')
                                  ? SvgPicture.asset(
                                      club.img!,
                                      width: 28,
                                      height: 28,
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                    )
                                  : Icon(Icons.group, color: Colors.white, size: 28),
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
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.primaryAccent.withOpacity(0.12),
                                      AppTheme.secondaryAccent.withOpacity(0.06),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: AppTheme.primaryAccent
                                          .withOpacity(0.25)),
                                ),
                                child: ShaderMask(
                                  shaderCallback: (bounds) => AppTheme
                                      .accentGradient
                                      .createShader(bounds),
                                  child: Text(
                                    k,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ShaderMask(
                                        shaderCallback: (bounds) => AppTheme
                                            .accentGradient
                                            .createShader(bounds),
                                        child: const Text('Focus',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                      const SizedBox(height: 6),
                                      ...club.focusAreas
                                          .take(3)
                                          .map((f) => Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 3),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text('• ',
                                                        style: TextStyle(
                                                            color: AppTheme
                                                                .primaryAccent,
                                                            fontSize: 12)),
                                                    Expanded(
                                                      child: Text(f,
                                                          style: TextStyle(
                                                              color: AppTheme
                                                                  .textSecondary,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ShaderMask(
                                        shaderCallback: (bounds) => AppTheme
                                            .cyanGradient
                                            .createShader(bounds),
                                        child: const Text('Activities',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                      const SizedBox(height: 6),
                                      ...club.activities
                                          .take(3)
                                          .map((a) => Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 3),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text('• ',
                                                        style: TextStyle(
                                                            color: AppTheme
                                                                .tertiaryAccent,
                                                            fontSize: 12)),
                                                    Expanded(
                                                      child: Text(a,
                                                          style: TextStyle(
                                                              color: AppTheme
                                                                  .textSecondary,
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
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: AppTheme.accentGradient,
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primaryAccent
                                          .withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.push('/home/clubs/apply',
                                        extra: club);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                  ),
                                  child: const Text('Apply Now',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.glassBorder,
                                      AppTheme.primaryAccent.withOpacity(0.2),
                                      AppTheme.glassBorder,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Container(
                                  margin: const EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                    color: AppTheme.backgroundDark,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: OutlinedButton(
                                    onPressed: () {
                                      _showKnowMore(context, club);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      side: BorderSide.none,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                    ),
                                    child: const Text('Know More',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
        decoration: BoxDecoration(
          color: AppTheme.backgroundLightGradient,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border(
            top: BorderSide(color: AppTheme.glassBorder),
          ),
        ),
        child: Column(
          children: [
            // Gradient handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                gradient: AppTheme.accentGradient,
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
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.primaryAccent.withOpacity(0.2),
                                AppTheme.secondaryAccent.withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppTheme.primaryAccent.withOpacity(0.15),
                                blurRadius: 15,
                              ),
                            ],
                          ),
                          child: ShaderMask(
                            shaderCallback: (bounds) =>
                                AppTheme.accentGradient.createShader(bounds),
                            child: Icon(
                              getClubIcon(club.abbr),
                              color: Colors.white,
                              size: 32,
                            ),
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
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            AppTheme.accentGradient.createShader(bounds),
                        child: const Text('Focus Areas',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                      ...club.focusAreas.map((f) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(children: [
                              Text('• ',
                                  style: TextStyle(
                                      color: AppTheme.primaryAccent)),
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
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            AppTheme.cyanGradient.createShader(bounds),
                        child: const Text('Activities',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                      ...club.activities.map((a) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(children: [
                              Text('• ',
                                  style: TextStyle(
                                      color: AppTheme.tertiaryAccent)),
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
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppTheme.accentGradient,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: AppTheme.glowShadow(),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            context.push('/home/clubs/apply', extra: club);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                          ),
                          child: Text('Apply to ${club.name}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                        ),
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
}

IconData getClubIcon(String abbr) {
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
    case 'ECELL':
    case 'EC':
      return Icons.rocket_launch_rounded;
    case 'GDXR':
      return Icons.videogame_asset_rounded;
    case 'ISDF':
      return Icons.security_rounded;
    case 'RND':
      return Icons.biotech_rounded;
    case 'CYCLE':
      return Icons.directions_bike_rounded;
    case 'NATURE':
      return Icons.eco_rounded;
    case 'MAG':
      return Icons.menu_book_rounded;
    case 'TECH':
      return Icons.engineering_rounded;
    case 'CUL':
      return Icons.palette_rounded;
    default:
      return Icons.groups_rounded;
  }
}
