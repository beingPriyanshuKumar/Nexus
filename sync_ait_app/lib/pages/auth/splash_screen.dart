import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../styles/app_theme.dart';
import '../../providers/auth/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    await ref.read(authProvider.notifier).checkAuth();
    if (!mounted) return;

    final state = ref.read(authProvider);
    if (state.isAuthenticated && state.user?.year != null) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.backgroundDark, AppTheme.backgroundLightGradient],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated Logo
              Icon(
                Icons.sync_rounded,
                size: 100,
                color: AppTheme.primaryAccent,
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1.0, 1.0),
                    curve: Curves.easeOutBack,
                    duration: 800.ms,
                  )
                  .then()
                  .shimmer(duration: 1200.ms, color: Colors.white24),

              const SizedBox(height: 24),

              // App Name
              Text(
                'SYNC AIT',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      letterSpacing: 4,
                      fontWeight: FontWeight.w900,
                    ),
              )
                  .animate()
                  .fadeIn(delay: 300.ms, duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),

              const SizedBox(height: 8),

              Text(
                'Your campus, connected.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
              )
                  .animate()
                  .fadeIn(delay: 600.ms, duration: 600.ms),

              const SizedBox(height: 48),

              // Loading indicator
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppTheme.primaryAccent.withOpacity(0.6),
                ),
              ).animate().fadeIn(delay: 900.ms, duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}
