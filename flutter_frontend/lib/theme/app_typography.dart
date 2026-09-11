import 'package:flutter/material.dart';

/// ── LeafCompass Design Tokens: Typography ──────────────────────────────────
/// Extension to fetch typography styles natively from the theme.
/// Replaces static AppTypography with context-aware styles.

extension AppTypographyExtension on BuildContext {
  TextStyle get display => Theme.of(this).textTheme.displayLarge!;
  TextStyle get headline => Theme.of(this).textTheme.headlineMedium!;
  TextStyle get titleLarge => Theme.of(this).textTheme.titleLarge!;
  TextStyle get titleMedium => Theme.of(this).textTheme.titleMedium!;
  TextStyle get bodyLarge => Theme.of(this).textTheme.bodyLarge!;
  TextStyle get bodyMedium => Theme.of(this).textTheme.bodyMedium!;
  TextStyle get bodySmall => Theme.of(this).textTheme.bodySmall!;
  TextStyle get labelLarge => Theme.of(this).textTheme.labelLarge!;
  TextStyle get labelMedium => Theme.of(this).textTheme.labelMedium!;
  TextStyle get labelSmall => Theme.of(this).textTheme.labelSmall!;
}
