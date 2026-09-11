import 'package:flutter/material.dart';
import 'app_colors_extension.dart';

/// ── LeafCompass Design Tokens: Color Palette ──────────────────────────────
/// "Modern Earth Science" direction — teal-green primary with terracotta accent.

class AppColors {
  AppColors._();

  static const AppColorsExtension light = AppColorsExtension(
    primary: Color(0xFF1A6B4A),
    primaryDark: Color(0xFF0D4F35),
    primaryLight: Color(0xFF2A8B60),
    primaryContainer: Color(0xFFD4F0E2),
    onPrimary: Colors.white,

    secondary: Color(0xFFC76F30),
    secondaryDark: Color(0xFFA05520),
    secondaryContainer: Color(0xFFFDECD6),
    onSecondary: Colors.white,

    tertiary: Color(0xFF4A7FB5),
    tertiaryContainer: Color(0xFFD6E8F7),

    surface: Color(0xFFF6F4F0),
    surfaceContainer: Color(0xFFFFFFFF),
    surfaceContainerHigh: Color(0xFFEDE9E3),
    surfaceDim: Color(0xFFE2DED8),

    onSurface: Color(0xFF1C1B18),
    onSurfaceVariant: Color(0xFF5C5A55),
    onSurfaceMuted: Color(0xFF8A8680),

    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Colors.white,
    success: Color(0xFF2E7D32),
    successContainer: Color(0xFFE8F5E9),

    accentDisease: Color(0xFFCF4545),
    accentDiseaseLight: Color(0xFFFDE8E8),
    accentYield: Color(0xFF4A7FB5),
    accentYieldLight: Color(0xFFD6E8F7),
    accentCrop: Color(0xFF2E9B60),
    accentCropLight: Color(0xFFD4F0E2),
    accentFertilizer: Color(0xFFC76F30),
    accentFertilizerLight: Color(0xFFFDECD6),
    accentChat: Color(0xFF7B5EA7),
    accentChatLight: Color(0xFFF0E8F7),

    heroGradient: [
      Color(0xFF0D4F35),
      Color(0xFF1A6B4A),
      Color(0xFF2A8B60),
    ],
    footerBg: Color(0xFF1C1B18),
    footerText: Color(0xFF9E9A94),
  );

  static const AppColorsExtension dark = AppColorsExtension(
    primary: Color(0xFF2A8B60), // Lighter for contrast
    primaryDark: Color(0xFF1A6B4A),
    primaryLight: Color(0xFF389F70),
    primaryContainer: Color(0xFF1A4633),
    onPrimary: Colors.white,

    secondary: Color(0xFFD98A52), // Lighter terracotta
    secondaryDark: Color(0xFFC76F30),
    secondaryContainer: Color(0xFF5A3010),
    onSecondary: Colors.white,

    tertiary: Color(0xFF679BCE),
    tertiaryContainer: Color(0xFF1D3B5C),

    surface: Color(0xFF121413),
    surfaceContainer: Color(0xFF1E2220),
    surfaceContainerHigh: Color(0xFF2B2E2C),
    surfaceDim: Color(0xFF0D0F0E),

    onSurface: Color(0xFFE2DED8),
    onSurfaceVariant: Color(0xFFA5A29D),
    onSurfaceMuted: Color(0xFF8A8680),

    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    success: Color(0xFF81C784),
    successContainer: Color(0xFF1B5E20),

    accentDisease: Color(0xFFE57373),
    accentDiseaseLight: Color(0xFF3D1C1C),
    accentYield: Color(0xFF64B5F6),
    accentYieldLight: Color(0xFF15334E),
    accentCrop: Color(0xFF4DB6AC),
    accentCropLight: Color(0xFF14453A),
    accentFertilizer: Color(0xFFFFB74D),
    accentFertilizerLight: Color(0xFF4A3414),
    accentChat: Color(0xFFBA68C8),
    accentChatLight: Color(0xFF3C2050),

    heroGradient: [
      Color(0xFF121413), // Blend nicely with dark mode surface
      Color(0xFF1A3326),
      Color(0xFF152A20),
    ],
    footerBg: Color(0xFF0D0F0E),
    footerText: Color(0xFF8A8680),
  );
}
