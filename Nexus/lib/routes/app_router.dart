import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/models/club_model.dart';
import '../pages/home/main_layout_screen.dart';
import '../pages/clubs/clubs_list_screen.dart';
import '../pages/clubs/club_application_screen.dart';
import '../pages/auth/login_screen.dart';
import '../pages/auth/register_screen.dart';
import '../pages/auth/verify_account_screen.dart';
import '../pages/profile/se_panel.dart';
import '../pages/profile/te_panel.dart';
import '../pages/profile/fe_panel.dart';

class AppRouter {
  static GoRouter get router => GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainLayoutScreen(),
        routes: [
          GoRoute(
            path: 'clubs',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const ClubsListScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(CurveTween(curve: Curves.easeOutQuint).animate(animation)),
                  child: child,
                );
              },
            ),
          ),
          GoRoute(
            path: 'clubs/apply',
            builder: (context, state) {
              final club = state.extra as ClubModel;
              return ClubApplicationScreen(club: club);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurveTween(curve: Curves.easeOutQuint).animate(animation)),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const RegisterScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(CurveTween(curve: Curves.easeOutQuint).animate(animation)),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: '/verify-account',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const VerifyAccountScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: '/profile/SE',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const SePanel(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: '/profile/TE',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const TePanel(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: '/profile/FE',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const FePanel(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        ),
      ),
    ],
  );
}
