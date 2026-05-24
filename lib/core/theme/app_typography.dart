import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Calcuon typography system.
///
/// Display: Space Grotesk — geometric, technical, distinctive
/// Body: DM Sans — clean, readable, pairs perfectly
/// Mono: JetBrains Mono — equations, expressions, code
abstract final class AppTypography {
  // ─── FONT FAMILIES ──────────────────────────────────────────

  static final String displayFont = GoogleFonts.spaceGrotesk().fontFamily!;
  static final String bodyFont = GoogleFonts.dmSans().fontFamily!;
  static final String monoFont = GoogleFonts.jetbrainsMono().fontFamily!;

  // ─── DISPLAY STYLES (Results, Headers) ──────────────────────

  static final TextStyle displayLarge = GoogleFonts.spaceGrotesk(
    fontSize: 48,
    fontWeight: FontWeight.w300,
    height: 1.1,
    letterSpacing: -1.5,
  );

  static final TextStyle displayMedium = GoogleFonts.spaceGrotesk(
    fontSize: 36,
    fontWeight: FontWeight.w300,
    height: 1.15,
    letterSpacing: -1.0,
  );

  static final TextStyle displaySmall = GoogleFonts.spaceGrotesk(
    fontSize: 28,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: -0.5,
  );

  // ─── HEADING STYLES ─────────────────────────────────────────

  static final TextStyle headlineLarge = GoogleFonts.spaceGrotesk(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 1.25,
    letterSpacing: -0.3,
  );

  static final TextStyle headlineMedium = GoogleFonts.spaceGrotesk(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: -0.2,
  );

  static final TextStyle headlineSmall = GoogleFonts.spaceGrotesk(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  // ─── BODY STYLES ────────────────────────────────────────────

  static final TextStyle bodyLarge = GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static final TextStyle bodyMedium = GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );

  static final TextStyle bodySmall = GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // ─── LABEL STYLES (Buttons, Chips) ──────────────────────────

  static final TextStyle labelLarge = GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.1,
  );

  static final TextStyle labelMedium = GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.35,
    letterSpacing: 0.2,
  );

  static final TextStyle labelSmall = GoogleFonts.dmSans(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0.3,
  );

  // ─── MONO STYLES (Expressions, Code) ────────────────────────

  static final TextStyle monoLarge = GoogleFonts.jetbrainsMono(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    height: 1.3,
    letterSpacing: -0.5,
  );

  static final TextStyle monoMedium = GoogleFonts.jetbrainsMono(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.35,
  );

  static final TextStyle monoSmall = GoogleFonts.jetbrainsMono(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // ─── CALCULATOR-SPECIFIC ────────────────────────────────────

  /// Main result display — large, light weight
  static final TextStyle resultDisplay = GoogleFonts.spaceGrotesk(
    fontSize: 56,
    fontWeight: FontWeight.w300,
    height: 1.0,
    letterSpacing: -2.0,
  );

  /// Expression being typed
  static final TextStyle expressionDisplay = GoogleFonts.jetbrainsMono(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 1.3,
    letterSpacing: -0.3,
  );

  /// Calculator button text
  static final TextStyle buttonText = GoogleFonts.spaceGrotesk(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    height: 1.0,
  );

  /// Small calculator button (scientific)
  static final TextStyle buttonTextSmall = GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.0,
  );

  /// Operator button text
  static final TextStyle operatorText = GoogleFonts.spaceGrotesk(
    fontSize: 28,
    fontWeight: FontWeight.w300,
    height: 1.0,
  );
}
