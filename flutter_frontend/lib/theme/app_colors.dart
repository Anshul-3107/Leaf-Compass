import 'package:flutter/material.dart';

/// ── LeafCompass Design Tokens: Color Palette ──────────────────────────────
/// "Modern Earth Science" direction — teal-green primary with terracotta accent.
/// Warm, grounded, professional.

class AppColors {
  AppColors._();

  // ── Primary (Deep Teal-Green) ──────────────────────────────────────────
  static const Color primary        = Color(0xFF1A6B4A);
  static const Color primaryDark    = Color(0xFF0D4F35);
  static const Color primaryLight   = Color(0xFF2A8B60);
  static const Color primaryContainer = Color(0xFFD4F0E2);
  static const Color onPrimary      = Colors.white;

  // ── Secondary (Terracotta / Amber) ─────────────────────────────────────
  static const Color secondary          = Color(0xFFC76F30);
  static const Color secondaryDark      = Color(0xFFA05520);
  static const Color secondaryContainer = Color(0xFFFDECD6);
  static const Color onSecondary        = Colors.white;

  // ── Tertiary (Steel Blue) ──────────────────────────────────────────────
  static const Color tertiary          = Color(0xFF4A7FB5);
  static const Color tertiaryContainer = Color(0xFFD6E8F7);

  // ── Surfaces ───────────────────────────────────────────────────────────
  static const Color surface              = Color(0xFFF6F4F0);  // Warm off-white
  static const Color surfaceContainer     = Color(0xFFFFFFFF);  // Cards
  static const Color surfaceContainerHigh = Color(0xFFEDE9E3);  // Input fills, dividers
  static const Color surfaceDim           = Color(0xFFE2DED8);  // Subtle separators

  // ── On Surface (Text) ──────────────────────────────────────────────────
  static const Color onSurface        = Color(0xFF1C1B18);  // Primary text
  static const Color onSurfaceVariant = Color(0xFF5C5A55);  // Secondary text
  static const Color onSurfaceMuted   = Color(0xFF8A8680);  // Placeholder/hint text

  // ── Semantic ───────────────────────────────────────────────────────────
  static const Color error           = Color(0xFFBA1A1A);
  static const Color errorContainer  = Color(0xFFFFDAD6);
  static const Color onError         = Colors.white;
  static const Color success         = Color(0xFF2E7D32);
  static const Color successContainer = Color(0xFFE8F5E9);

  // ── Feature Accent Colors (for per-screen identity) ────────────────────
  static const Color accentDisease    = Color(0xFFCF4545);
  static const Color accentDiseaseLight = Color(0xFFFDE8E8);
  static const Color accentYield      = Color(0xFF4A7FB5);
  static const Color accentYieldLight = Color(0xFFD6E8F7);
  static const Color accentCrop       = Color(0xFF2E9B60);
  static const Color accentCropLight  = Color(0xFFD4F0E2);
  static const Color accentFertilizer = Color(0xFFC76F30);
  static const Color accentFertilizerLight = Color(0xFFFDECD6);
  static const Color accentChat       = Color(0xFF7B5EA7);
  static const Color accentChatLight  = Color(0xFFF0E8F7);

  // ── Hero Gradient ──────────────────────────────────────────────────────
  static const List<Color> heroGradient = [
    Color(0xFF0D4F35),
    Color(0xFF1A6B4A),
    Color(0xFF2A8B60),
  ];

  // ── Footer ─────────────────────────────────────────────────────────────
  static const Color footerBg   = Color(0xFF1C1B18);
  static const Color footerText = Color(0xFF9E9A94);
}
