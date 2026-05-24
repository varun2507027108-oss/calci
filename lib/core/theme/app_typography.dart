import 'package:flutter/material.dart';

/// Calcuon typography system.
///
/// Display: Space Grotesk — geometric, technical, distinctive
/// Body: DM Sans — clean, readable, pairs perfectly
/// Mono: JetBrains Mono — equations, expressions, code
abstract final class AppTypography {
  // ─── FONT FAMILIES ──────────────────────────────────────────

  static const String displayFont = 'SpaceGrotesk';
  static const String bodyFont = 'DMSans';
  static const String monoFont = 'JetBrainsMono';

  // ─── DISPLAY STYLES (Results, Headers) ──────────────────────

  static const TextStyle displayLarge = TextStyle(
    fontFamily: displayFont,
    fontSize: 48,
    fontWeight: FontWeight.w300,
    height: 1.1,
    letterSpacing: -1.5,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: displayFont,
    fontSize: 36,
    fontWeight: FontWeight.w300,
    height: 1.15,
    letterSpacing: -1.0,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: displayFont,
    fontSize: 28,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: -0.5,
  );

  // ─── HEADING STYLES ─────────────────────────────────────────

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: displayFont,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 1.25,
    letterSpacing: -0.3,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: displayFont,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: -0.2,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: displayFont,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  // ─── BODY STYLES ────────────────────────────────────────────

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // ─── LABEL STYLES (Buttons, Chips) ──────────────────────────

  static const TextStyle labelLarge = TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.35,
    letterSpacing: 0.2,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: bodyFont,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0.3,
  );

  // ─── MONO STYLES (Expressions, Code) ────────────────────────

  static const TextStyle monoLarge = TextStyle(
    fontFamily: monoFont,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    height: 1.3,
    letterSpacing: -0.5,
  );

  static const TextStyle monoMedium = TextStyle(
    fontFamily: monoFont,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.35,
  );

  static const TextStyle monoSmall = TextStyle(
    fontFamily: monoFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // ─── CALCULATOR-SPECIFIC ────────────────────────────────────

  /// Main result display — large, light weight
  static const TextStyle resultDisplay = TextStyle(
    fontFamily: displayFont,
    fontSize: 56,
    fontWeight: FontWeight.w300,
    height: 1.0,
    letterSpacing: -2.0,
  );

  /// Expression being typed
  static const TextStyle expressionDisplay = TextStyle(
    fontFamily: monoFont,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 1.3,
    letterSpacing: -0.3,
  );

  /// Calculator button text
  static const TextStyle buttonText = TextStyle(
    fontFamily: displayFont,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    height: 1.0,
  );

  /// Small calculator button (scientific)
  static const TextStyle buttonTextSmall = TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.0,
  );

  /// Operator button text
  static const TextStyle operatorText = TextStyle(
    fontFamily: displayFont,
    fontSize: 28,
    fontWeight: FontWeight.w300,
    height: 1.0,
  );
}
