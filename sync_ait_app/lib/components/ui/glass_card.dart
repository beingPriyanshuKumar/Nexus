import 'dart:ui';
import 'package:flutter/material.dart';
import '../../styles/app_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final defaultRadius = borderRadius ?? BorderRadius.circular(24);

    Widget card = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.glassSurface,
        borderRadius: defaultRadius,
        border: Border.all(
          color: AppTheme.glassBorder,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: defaultRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Padding(
            padding: padding!,
            child: child,
          ),
        ),
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: defaultRadius as BorderRadius,
          onTap: onTap,
          highlightColor: Colors.white.withOpacity(0.05),
          splashColor: Colors.white.withOpacity(0.1),
          child: card,
        ),
      );
    }

    return card;
  }
}
