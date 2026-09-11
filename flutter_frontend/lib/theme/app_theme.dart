import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_colors_extension.dart';
import 'app_spacing.dart';

/// ── LeafCompass Centralized Theme ──────────────────────────────────────────
/// Single source of truth for Material 3 theming.

class AppTheme {
  AppTheme._();

  static ThemeData _buildTheme(AppColorsExtension colors, Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      extensions: [colors],
      
      // ── Color Scheme ─────────────────────────────────────────────────
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors.primary,
        brightness: brightness,
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        primaryContainer: colors.primaryContainer,
        secondary: colors.secondary,
        onSecondary: colors.onSecondary,
        secondaryContainer: colors.secondaryContainer,
        tertiary: colors.tertiary,
        tertiaryContainer: colors.tertiaryContainer,
        surface: colors.surface,
        onSurface: colors.onSurface,
        onSurfaceVariant: colors.onSurfaceVariant,
        error: colors.error,
        onError: colors.onError,
        errorContainer: colors.errorContainer,
      ),

      // ── Scaffold ─────────────────────────────────────────────────────
      scaffoldBackgroundColor: colors.surface,

      // ── Text Theme ───────────────────────────────────────────────────
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(
            fontSize: 28, fontWeight: FontWeight.w800, height: 1.15,
            color: colors.onSurface),
        headlineMedium: GoogleFonts.inter(
            fontSize: 22, fontWeight: FontWeight.w700, height: 1.2,
            color: colors.onSurface),
        titleLarge: GoogleFonts.inter(
            fontSize: 18, fontWeight: FontWeight.w700, height: 1.3,
            color: colors.onSurface),
        titleMedium: GoogleFonts.inter(
            fontSize: 16, fontWeight: FontWeight.w600, height: 1.35,
            color: colors.onSurface),
        bodyLarge: GoogleFonts.inter(
            fontSize: 15, fontWeight: FontWeight.w400, height: 1.5,
            color: colors.onSurface),
        bodyMedium: GoogleFonts.inter(
            fontSize: 14, fontWeight: FontWeight.w400, height: 1.5,
            color: colors.onSurface),
        bodySmall: GoogleFonts.inter(
            fontSize: 13, fontWeight: FontWeight.w400, height: 1.45,
            color: colors.onSurfaceVariant),
        labelLarge: GoogleFonts.inter(
            fontSize: 13, fontWeight: FontWeight.w600, height: 1.3,
            color: colors.onSurface),
        labelMedium: GoogleFonts.inter(
            fontSize: 12, fontWeight: FontWeight.w600, height: 1.3,
            color: colors.onSurfaceVariant),
        labelSmall: GoogleFonts.inter(
            fontSize: 11, fontWeight: FontWeight.w700, height: 1.2,
            letterSpacing: 0.8, color: colors.onSurfaceMuted),
      ),

      // ── App Bar ──────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 0,
        scrolledUnderElevation: 2,
        titleTextStyle: GoogleFonts.inter(
          color: colors.onPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),

      // ── Elevated Button ──────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          disabledBackgroundColor: colors.surfaceDim,
          disabledForegroundColor: colors.onSurfaceMuted,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          elevation: 0,
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),

      // ── Outlined Button ──────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          side: BorderSide(color: colors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),

      // ── Input Decoration ─────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: colors.surfaceDim),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: colors.surfaceDim),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: colors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: colors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: GoogleFonts.inter(
            fontSize: 13, color: colors.onSurfaceVariant),
        hintStyle: GoogleFonts.inter(
            fontSize: 13, color: colors.onSurfaceMuted),
        floatingLabelStyle: GoogleFonts.inter(
            fontSize: 13, fontWeight: FontWeight.w600, color: colors.primary),
      ),

      // ── Card ─────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: colors.surfaceContainer,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          side: BorderSide(color: colors.surfaceDim, width: 1),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6),
      ),

      // ── Navigation Bar ───────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.surfaceContainer,
        indicatorColor: colors.primaryContainer,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: colors.primary,
                fontSize: 12);
          }
          return GoogleFonts.inter(
              fontSize: 11,
              color: colors.onSurfaceMuted);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colors.primary, size: 24);
          }
          return IconThemeData(color: colors.onSurfaceMuted, size: 22);
        }),
      ),

      // ── Bottom Sheet ─────────────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surfaceContainer,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),

      // ── Divider ──────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: colors.surfaceDim,
        thickness: 1,
        space: 1,
      ),

      // ── Dropdown Menu ────────────────────────────────────────────────
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: colors.surfaceContainerHigh,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: BorderSide(color: colors.surfaceDim),
          ),
        ),
      ),
    );
  }

  static ThemeData get light => _buildTheme(AppColors.light, Brightness.light);
  static ThemeData get dark => _buildTheme(AppColors.dark, Brightness.dark);
}
