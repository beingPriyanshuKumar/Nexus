import 'package:flutter/material.dart';
import '../../styles/app_theme.dart';

class AppNavbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppNavbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: AppTheme.backgroundDark.withOpacity(0.8),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
