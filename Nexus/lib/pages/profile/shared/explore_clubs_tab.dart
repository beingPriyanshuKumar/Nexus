import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../styles/app_theme.dart';
import '../../../utils/models/mock_clubs.dart';
import '../../../components/club_detail_card.dart';

class ExploreClubsTab extends StatefulWidget {
  const ExploreClubsTab({super.key});

  @override
  State<ExploreClubsTab> createState() => _ExploreClubsTabState();
}

class _ExploreClubsTabState extends State<ExploreClubsTab> {
  String _searchTerm = '';

  @override
  Widget build(BuildContext context) {
    final filtered = mockClubs.where((c) =>
        c.name.toLowerCase().contains(_searchTerm.toLowerCase()) ||
        (c.desc?.toLowerCase().contains(_searchTerm.toLowerCase()) ?? false) ||
        c.keywords.any((k) => k.toLowerCase().contains(_searchTerm.toLowerCase()))
    ).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ShaderMask(
            shaderCallback: (bounds) => AppTheme.accentGradient.createShader(bounds),
            child: Text(
              'Explore Clubs',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
            ),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 4),
          Text(
            'Discover and join clubs that match your interests.',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
          ),

          const SizedBox(height: 20),

          // Search bar
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassSurface : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? AppTheme.glassBorder : AppTheme.lightBorder),
            ),
            child: TextField(
              onChanged: (v) => setState(() => _searchTerm = v),
              style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: 'Search clubs by name or keyword...',
                hintStyle: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                prefixIcon: ShaderMask(
                  shaderCallback: (bounds) => AppTheme.accentGradient.createShader(bounds),
                  child: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface, size: 22),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Clubs grid
          if (filtered.isEmpty)
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Icon(Icons.search_off, size: 48, color: AppTheme.textSecondary.withOpacity(0.3)),
                  const SizedBox(height: 12),
                  Text('No clubs found.', style: TextStyle(color: AppTheme.textSecondary)),
                ],
              ),
            )
          else
            AnimationLimiter(
              child: Column(
                children: List.generate(filtered.length, (index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: 30,
                      child: FadeInAnimation(
                        child: ClubDetailCard(club: filtered[index]),
                      ),
                    ),
                  );
                }),
              ),
            ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
