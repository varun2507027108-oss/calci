import 'dart:ui';
import 'package:flutter/material.dart';

/// Calcuon color system — Matte Titanium Dark aesthetic.
///
/// Warm blacks, graphite surfaces, amber gold accents, deep emerald secondary.
/// Avoids generic blue/purple neon. Feels like a precision instrument.
abstract final class AppColors {
  // ─── DARK MODE ──────────────────────────────────────────────

  static const Color darkSurfacePrimary = Color(0xFF0D0D0F);
  static const Color darkSurfaceElevated = Color(0xFF18181C);
  static const Color darkSurfaceGlass = Color(0xCC1E1E24);
  static const Color darkSurfaceKeypad = Color(0xFF141418);

  static const Color darkBorderSubtle = Color(0xFF2A2A30);
  static const Color darkBorderAccent = Color(0xFF3A3A42);

  static const Color darkTextPrimary = Color(0xFFF0EDE8);
  static const Color darkTextSecondary = Color(0xFF8A8690);
  static const Color darkTextTertiary = Color(0xFF5A5660);

  static const Color darkButtonDefault = Color(0xFF1C1C22);
  static const Color darkButtonOperator = Color(0xFF252530);
  static const Color darkButtonAction = Color(0xFFD4A853);
  static const Color darkButtonPressed = Color(0xFF2A2A35);
  static const Color darkButtonScientific = Color(0xFF1A1A20);

  // ─── LIGHT MODE ─────────────────────────────────────────────

  static const Color lightSurfacePrimary = Color(0xFFF5F3F0);
  static const Color lightSurfaceElevated = Color(0xFFFFFFFF);
  static const Color lightSurfaceGlass = Color(0xCCFFFFFF);
  static const Color lightSurfaceKeypad = Color(0xFFF0EDE8);

  static const Color lightBorderSubtle = Color(0xFFE5E2DD);
  static const Color lightBorderAccent = Color(0xFFD5D2CD);

  static const Color lightTextPrimary = Color(0xFF1A1A1E);
  static const Color lightTextSecondary = Color(0xFF6B6770);
  static const Color lightTextTertiary = Color(0xFF9A9698);

  static const Color lightButtonDefault = Color(0xFFFFFFFF);
  static const Color lightButtonOperator = Color(0xFFF0EDE8);
  static const Color lightButtonAction = Color(0xFFB8892F);
  static const Color lightButtonPressed = Color(0xFFE8E5E0);
  static const Color lightButtonScientific = Color(0xFFF5F3F0);

  // ─── SHARED ACCENTS ─────────────────────────────────────────

  static const Color accentAmber = Color(0xFFD4A853);
  static const Color accentAmberLight = Color(0xFFE8C878);
  static const Color accentAmberDark = Color(0xFFB8892F);

  static const Color accentEmerald = Color(0xFF2D8B6F);
  static const Color accentEmeraldLight = Color(0xFF3AAE8C);
  static const Color accentEmeraldDark = Color(0xFF1D6B4F);

  static const Color accentTerracotta = Color(0xFFC75B39);
  static const Color accentTerracottaLight = Color(0xFFE07050);
  static const Color accentTerracottaDark = Color(0xFFA84828);

  // ─── GRAPH COLORS ───────────────────────────────────────────

  static const List<Color> graphPalette = [
    Color(0xFFD4A853), // amber
    Color(0xFF2D8B6F), // emerald
    Color(0xFFC75B39), // terracotta
    Color(0xFF6B8EBF), // steel blue
    Color(0xFFB07CC6), // muted lavender
    Color(0xFF5BA88C), // sage
    Color(0xFFD4775B), // coral
    Color(0xFF8B9EAF), // slate
  ];

  // ─── SEMANTIC COLORS ────────────────────────────────────────

  static const Color success = Color(0xFF2D8B6F);
  static const Color warning = Color(0xFFD4A853);
  static const Color error = Color(0xFFC75B39);
  static const Color info = Color(0xFF6B8EBF);

  // ─── GLASS EFFECT ───────────────────────────────────────────

  static const double glassBlur = 12.0;
  static const double glassSaturation = 1.2;
  static const double glassOpacity = 0.8;
}
