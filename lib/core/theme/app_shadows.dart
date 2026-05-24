import 'package:flutter/material.dart';

/// Calcuon shadow system — depth layering for the titanium aesthetic.
///
/// Uses warm-tinted shadows for dark mode, neutral for light mode.
/// Three depth levels + inner shadow for pressed states.
abstract final class AppShadows {
  // ─── DARK MODE SHADOWS ──────────────────────────────────────

  static const List<BoxShadow> darkElevation1 = [
    BoxShadow(
      color: Color(0x66000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> darkElevation2 = [
    BoxShadow(
      color: Color(0x80000000),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> darkElevation3 = [
    BoxShadow(
      color: Color(0x99000000),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x4D000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  /// Pressed/active button inner shadow
  static const List<BoxShadow> darkInner = [
    BoxShadow(
      color: Color(0x4D000000),
      blurRadius: 2,
      offset: Offset(0, 1),
      spreadRadius: -1,
    ),
  ];

  /// Subtle top edge highlight on buttons (simulates chamfer)
  static const List<BoxShadow> darkButtonHighlight = [
    BoxShadow(
      color: Color(0x1AFFFFFF),
      blurRadius: 1,
      offset: Offset(0, -1),
    ),
    BoxShadow(
      color: Color(0x66000000),
      blurRadius: 6,
      offset: Offset(0, 3),
    ),
  ];

  // ─── LIGHT MODE SHADOWS ─────────────────────────────────────

  static const List<BoxShadow> lightElevation1 = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> lightElevation2 = [
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> lightElevation3 = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> lightButtonHighlight = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
}
