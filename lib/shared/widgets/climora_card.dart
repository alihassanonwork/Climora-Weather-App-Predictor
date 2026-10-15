import 'package:flutter/material.dart';
import '../../core/theme/climora_colors.dart';

/// Reusable card component featuring rounded corners, subtle borders, and elevation.
class ClimoraCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final Color? backgroundColor;
  final double borderRadius;
  final Border? border;

  const ClimoraCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.margin,
    this.onTap,
    this.gradient,
    this.backgroundColor,
    this.borderRadius = 24.0,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBg = isDark ? ClimoraColors.cardDark : ClimoraColors.cardLight;
    final defaultBorder = Border.all(
      color: isDark ? ClimoraColors.borderDark : ClimoraColors.borderLight,
      width: 1,
    );

    Widget content = Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? (backgroundColor ?? defaultBg) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border ?? defaultBorder,
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? Colors.black.withAlpha(50)
                    : const Color(0xFF0F172A).withAlpha(12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: content,
        ),
      );
    }

    return content;
  }
}
