import 'package:flutter/material.dart';
import '../theme/app_colors_extension.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Reusable error banner — replaces duplicated error containers
/// in disease_screen.dart and prediction_form.dart.
class ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;

  const ErrorBanner({super.key, required this.message, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.themeColors.errorContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: context.themeColors.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: context.themeColors.error.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.error_outline,
                color: context.themeColors.error, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              message,
              style: context.bodySmall.copyWith(
                color: context.themeColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (onDismiss != null)
            IconButton(
              icon: Icon(Icons.close,
                  size: 18, color: context.themeColors.error.withValues(alpha: 0.6)),
              onPressed: onDismiss,
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    ).animate().fadeIn(duration: 250.ms);
  }
}
