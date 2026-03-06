import 'dart:ui';
import 'package:flutter/material.dart';
import '../../styles/app_theme.dart';

class AppNavbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppNavbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.backgroundDark.withOpacity(0.7),
            border: const Border(
              bottom: BorderSide(color: AppTheme.glassBorder, width: 0.5),
            ),
          ),
          child: AppBar(
            title: Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: AppTheme.accentGradient,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
