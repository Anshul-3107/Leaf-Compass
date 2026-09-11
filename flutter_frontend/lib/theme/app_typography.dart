import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// ── LeafCompass Design Tokens: Typography ──────────────────────────────────
/// Formalized type scale using Inter.

class AppTypography {
  AppTypography._();

  // ── Display (hero headlines, large result values) ──────────────────────
  static TextStyle display = GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    height: 1.15,
    color: AppColors.onSurface,
  );

  // ── Headline (screen titles, section headers) ──────────────────────────
  static TextStyle headline = GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.onSurface,
  );

  // ── Title Large (card titles, form screen intros) ──────────────────────
  static TextStyle titleLarge = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: AppColors.onSurface,
  );

  // ── Title Medium (sub-headings, chat header) ───────────────────────────
  static TextStyle titleMedium = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.35,
    color: AppColors.onSurface,
  );

  // ── Body Large (primary body text, form labels) ────────────────────────
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.onSurface,
  );

  // ── Body Medium (chat messages, descriptions) ──────────────────────────
  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.onSurface,
  );

  // ── Body Small (secondary text, hints) ─────────────────────────────────
  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.45,
    color: AppColors.onSurfaceVariant,
  );

  // ── Label Large (button labels, tab labels) ────────────────────────────
  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.onSurface,
  );

  // ── Label Medium (chips, badges, nav labels) ───────────────────────────
  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.onSurfaceVariant,
  );

  // ── Label Small (overline / category labels) ───────────────────────────
  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0.8,
    color: AppColors.onSurfaceMuted,
  );
}
