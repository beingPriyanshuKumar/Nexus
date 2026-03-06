import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../styles/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Typewriter state
  final List<String> _phrases = [
    'where every club finds home',
    'where every student community connects',
    'where your campus gets smarter',
  ];
  int _phraseIndex = 0;
  String _displayText = '';
  bool _isDeleting = false;
  Timer? _timer;

  // Marquee clubs
  static const _clubNames = [
    'OSS', 'GDG', 'CP', 'PR Cell', 'Radio Raga', 'E Cell',
    'EV Club', 'GDXR', 'ISDF', 'Sports Club', 'Cultural Board',
    'Technical Board', 'RnD Cell', 'Cycling Club', 'NSS',
    'Nature Club', 'MAGBOARD', 'MINERVA', 'FEET TAPPERS',
  ];

  @override
  void initState() {
    super.initState();
    _startTypewriter();
  }

  void _startTypewriter() {
    _timer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      final currentPhrase = _phrases[_phraseIndex];

      setState(() {
        if (!_isDeleting) {
          if (_displayText.length < currentPhrase.length) {
            _displayText = currentPhrase.substring(0, _displayText.length + 1);
          } else {
            _timer?.cancel();
            Future.delayed(const Duration(milliseconds: 1500), () {
              if (mounted) {
                _isDeleting = true;
                _startTypewriter();
              }
            });
          }
        } else {
          if (_displayText.isNotEmpty) {
            _displayText =
                _displayText.substring(0, _displayText.length - 1);
          } else {
            _isDeleting = false;
            _phraseIndex = (_phraseIndex + 1) % _phrases.length;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // ─── Hero Section ──────────────────────────────
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Main Title with gradient
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        AppTheme.accentGradient.createShader(bounds),
                    child: Text(
                      'YOUR CAMPUS\nJUST GOT\nSMARTER',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: 42,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            height: 1.1,
                            color: Colors.white,
                          ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 800.ms)
                      .slideY(begin: 0.3, end: 0, curve: Curves.easeOutBack),

                  const SizedBox(height: 20),

                  // Typewriter Text
                  SizedBox(
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _displayText,
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: 1.0,
                          duration: const Duration(milliseconds: 500),
                          child: ShaderMask(
                            shaderCallback: (bounds) =>
                                AppTheme.accentGradient.createShader(bounds),
                            child: const Text(
                              '|',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        )
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .fadeIn(duration: 500.ms)
                            .then()
                            .fadeOut(duration: 500.ms),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // CTA Button — Explore Clubs
                  Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.accentGradient,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryAccent.withOpacity(0.35),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () => context.push('/home/clubs'),
                      icon: const Icon(Icons.explore_rounded, size: 20),
                      label: const Text('Explore Clubs'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 600.ms)
                      .slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 20),

                  // Login / Sign Up Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Login button with gradient border
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.glassBorder,
                              AppTheme.primaryAccent.withOpacity(0.4),
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
                          child: OutlinedButton.icon(
                            onPressed: () => context.push('/login'),
                            icon: const Icon(Icons.login_rounded, size: 18),
                            label: const Text('Login'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide.none,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Sign Up button with gradient fill
                      Container(
                        decoration: BoxDecoration(
                          gradient: AppTheme.cyanGradient,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.secondaryAccent.withOpacity(0.25),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () => context.push('/register'),
                          icon: const Icon(Icons.person_add_rounded, size: 18),
                          label: const Text('Sign Up'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 600.ms)
                      .slideY(begin: 0.2, end: 0),
                ],
              ),
            ),
          ),

          // ─── Scrolling Marquee ─────────────────────────
          SizedBox(
            height: 50,
            child: _ClubMarquee(clubs: _clubNames),
          ).animate().fadeIn(delay: 800.ms, duration: 600.ms),

          const SizedBox(height: 40),

          // ─── About Section ─────────────────────────────
          _AboutSection(),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

// ─── Club Marquee ────────────────────────────────────────────────

class _ClubMarquee extends StatefulWidget {
  final List<String> clubs;
  const _ClubMarquee({required this.clubs});

  @override
  State<_ClubMarquee> createState() => _ClubMarqueeState();
}

class _ClubMarqueeState extends State<_ClubMarquee>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  double _scrollPosition = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScroll());
  }

  void _startScroll() async {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 30));
      if (!mounted || !_scrollController.hasClients) continue;
      _scrollPosition += 1;
      if (_scrollPosition >= _scrollController.position.maxScrollExtent) {
        _scrollPosition = 0;
      }
      _scrollController.jumpTo(_scrollPosition);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = [...widget.clubs, ...widget.clubs, ...widget.clubs];
    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Text(
                items[index],
                style: TextStyle(
                  color: AppTheme.textSecondary.withOpacity(0.6),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(width: 12),
              ShaderMask(
                shaderCallback: (bounds) =>
                    AppTheme.accentGradient.createShader(bounds),
                child: Text(
                  '⬥',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── About Section ───────────────────────────────────────────────

class _AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (bounds) =>
                AppTheme.accentGradient.createShader(bounds),
            child: Text(
              'ABOUT US',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    letterSpacing: 3,
                    color: Colors.white,
                  ),
            ),
          ).animate().fadeIn(duration: 500.ms),

          const SizedBox(height: 24),

          // SYNC AIT Description with left gradient border
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gradient accent bar
                Container(
                  width: 4,
                  height: 180,
                  decoration: BoxDecoration(
                    gradient: AppTheme.accentGradient,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 16),
                // Content
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.glassSurface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.glassBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) =>
                              AppTheme.accentGradient.createShader(bounds),
                          child: Text(
                            'NEXUS',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 3,
                          width: 60,
                          decoration: BoxDecoration(
                            gradient: AppTheme.accentGradient,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'System for Networked Clubs AIT Pune is a central hub for '
                          'all college clubs. Our platform unifies various student organizations '
                          'under one roof. We aim to foster collaboration, streamline event management, '
                          'and enhance communication among club members and the wider student body.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                height: 1.6,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 500.ms).slideY(
                begin: 0.1,
                end: 0,
              ),

          const SizedBox(height: 16),

          // Vision & Mission
          Row(
            children: [
              Expanded(
                child: _InfoCard(
                  title: 'VISION',
                  content:
                      'To create a vibrant and connected campus where every student can effortlessly find their community.',
                  gradient: AppTheme.accentGradient,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _InfoCard(
                  title: 'MISSION',
                  content:
                      'To empower clubs with digital tools for data management and event promotion.',
                  gradient: AppTheme.cyanGradient,
                ),
              ),
            ],
          ).animate().fadeIn(delay: 400.ms, duration: 500.ms),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String content;
  final LinearGradient gradient;

  const _InfoCard({
    required this.title,
    required this.content,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.glassSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient accent strip at top
          Container(
            height: 3,
            width: 30,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          ShaderMask(
            shaderCallback: (bounds) => gradient.createShader(bounds),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
