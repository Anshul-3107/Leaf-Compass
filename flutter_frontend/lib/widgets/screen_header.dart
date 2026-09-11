import 'package:flutter/material.dart';
import '../theme/app_colors_extension.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Contextual intro header for tool screens.
/// Provides icon, title, and description so each screen has visual identity
/// instead of jumping straight into a bare form.
class ScreenHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color? accentColor;

  const ScreenHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xxl),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: (accentColor ?? context.themeColors.primary).withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border(
          left: BorderSide(color: accentColor ?? context.themeColors.primary, width: 4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: (accentColor ?? context.themeColors.primary).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(icon, color: accentColor ?? context.themeColors.primary, size: 24),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.titleLarge),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: context.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.03, end: 0, duration: 300.ms);
  }
}
