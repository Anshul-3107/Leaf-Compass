import 'package:flutter/material.dart';
import '../theme/app_colors_extension.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Reusable result card — replaces duplicated result containers
/// in disease_screen.dart and prediction_form.dart.
class ResultCard extends StatelessWidget {
  /// The primary value to display (e.g., crop name, yield number).
  final String displayValue;

  /// Optional unit suffix (e.g., "kg/ha").
  final String? unit;

  /// Optional label above the value (defaults to "PREDICTION RESULT").
  final String label;

  /// Optional accent color for the left edge and value text.
  final Color? accentColor;

  /// Optional subtitle below the value.
  final String? subtitle;

  /// Optional confidence value (0.0 – 1.0) to show a progress bar.
  final double? confidence;

  const ResultCard({
    super.key,
    required this.displayValue,
    this.unit,
    this.label = 'PREDICTION RESULT',
    this.accentColor,
    this.subtitle,
    this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: context.themeColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: context.themeColors.surfaceDim),
        boxShadow: [
          BoxShadow(
            color: (accentColor ?? context.themeColors.primary).withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Accent bar at top ──
          Container(
            height: 4,
            margin: const EdgeInsets.only(bottom: AppSpacing.lg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              gradient: LinearGradient(
                colors: [accentColor ?? context.themeColors.primary, (accentColor ?? context.themeColors.primary).withValues(alpha: 0.3)],
              ),
            ),
          ),

          // ── Label ──
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline,
                  size: 16, color: accentColor ?? context.themeColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                label,
                style: context.labelSmall.copyWith(
                  color: context.themeColors.onSurfaceMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Value ──
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  displayValue,
                  textAlign: TextAlign.center,
                  style: context.display.copyWith(
                    color: accentColor ?? context.themeColors.primary,
                    fontSize: 30,
                  ),
                ),
              ),
              if (unit != null) ...[
                const SizedBox(width: AppSpacing.sm),
                Text(
                  unit!,
                  style: context.titleMedium.copyWith(
                    color: context.themeColors.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),

          // ── Subtitle ──
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: context.bodySmall,
            ),
          ],

          // ── Confidence bar ──
          if (confidence != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Confidence: ${(confidence! * 100).toStringAsFixed(1)}%',
              style: context.labelMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              child: LinearProgressIndicator(
                value: confidence!,
                minHeight: 8,
                backgroundColor: context.themeColors.surfaceContainerHigh,
                valueColor: AlwaysStoppedAnimation<Color>(accentColor ?? context.themeColors.primary),
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 350.ms).scale(
        begin: const Offset(0.96, 0.96),
        end: const Offset(1, 1),
        duration: 350.ms);
  }
}
