import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_radius.dart';

/// Calcuon theme system.
///
/// Builds complete ThemeData for dark and light modes from design tokens.
/// Every component theme is explicitly defined — no Material defaults leak through.
abstract final class AppTheme {
  // Expose key colors for system chrome
  static const Color darkSurfacePrimary = AppColors.darkSurfacePrimary;
  static const Color lightSurfacePrimary = AppColors.lightSurfacePrimary;

  // ─── DARK THEME ─────────────────────────────────────────────

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkSurfacePrimary,
        colorScheme: const ColorScheme.dark(
          surface: AppColors.darkSurfacePrimary,
          onSurface: AppColors.darkTextPrimary,
          primary: AppColors.accentAmber,
          onPrimary: AppColors.darkSurfacePrimary,
          secondary: AppColors.accentEmerald,
          onSecondary: AppColors.darkTextPrimary,
          error: AppColors.accentTerracotta,
          onError: AppColors.darkTextPrimary,
          surfaceContainerHighest: AppColors.darkSurfaceElevated,
        ),
        textTheme: _buildTextTheme(AppColors.darkTextPrimary, AppColors.darkTextSecondary),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: AppTypography.displayFont,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.darkTextPrimary,
          ),
          iconTheme: const IconThemeData(color: AppColors.darkTextSecondary),
        ),
        cardTheme: CardThemeData(
          color: AppColors.darkSurfaceElevated,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.card),
            side: const BorderSide(color: AppColors.darkBorderSubtle, width: 0.5),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppColors.accentAmber,
          unselectedItemColor: AppColors.darkTextTertiary,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: TextStyle(
            fontFamily: AppTypography.bodyFont,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: AppTypography.bodyFont,
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.darkBorderSubtle,
          thickness: 0.5,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkSurfaceElevated,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(color: AppColors.darkBorderSubtle, width: 0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(color: AppColors.darkBorderSubtle, width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(color: AppColors.accentAmber, width: 1.0),
          ),
          hintStyle: TextStyle(
            fontFamily: AppTypography.bodyFont,
            color: AppColors.darkTextTertiary,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        iconTheme: const IconThemeData(
          color: AppColors.darkTextSecondary,
          size: 22,
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return AppColors.accentAmber;
            return AppColors.darkTextTertiary;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return AppColors.accentAmber.withValues(alpha: 0.3);
            return AppColors.darkBorderSubtle;
          }),
        ),
        splashFactory: InkSparkle.splashFactory,
      );

  // ─── LIGHT THEME ────────────────────────────────────────────

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.lightSurfacePrimary,
        colorScheme: const ColorScheme.light(
          surface: AppColors.lightSurfacePrimary,
          onSurface: AppColors.lightTextPrimary,
          primary: AppColors.accentAmberDark,
          onPrimary: AppColors.lightSurfaceElevated,
          secondary: AppColors.accentEmeraldDark,
          onSecondary: AppColors.lightSurfaceElevated,
          error: AppColors.accentTerracotta,
          onError: AppColors.lightSurfaceElevated,
          surfaceContainerHighest: AppColors.lightSurfaceElevated,
        ),
        textTheme: _buildTextTheme(AppColors.lightTextPrimary, AppColors.lightTextSecondary),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: AppTypography.displayFont,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.lightTextPrimary,
          ),
          iconTheme: const IconThemeData(color: AppColors.lightTextSecondary),
        ),
        cardTheme: CardThemeData(
          color: AppColors.lightSurfaceElevated,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.card),
            side: const BorderSide(color: AppColors.lightBorderSubtle, width: 0.5),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppColors.accentAmberDark,
          unselectedItemColor: AppColors.lightTextTertiary,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: TextStyle(
            fontFamily: AppTypography.bodyFont,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: AppTypography.bodyFont,
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.lightBorderSubtle,
          thickness: 0.5,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.lightSurfaceElevated,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(color: AppColors.lightBorderSubtle, width: 0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(color: AppColors.lightBorderSubtle, width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            borderSide: const BorderSide(color: AppColors.accentAmberDark, width: 1.0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        splashFactory: InkSparkle.splashFactory,
      );

  // ─── HELPERS ────────────────────────────────────────────────

  static TextTheme _buildTextTheme(Color primary, Color secondary) {
    return TextTheme(
      displayLarge: AppTypography.displayLarge.copyWith(color: primary),
      displayMedium: AppTypography.displayMedium.copyWith(color: primary),
      displaySmall: AppTypography.displaySmall.copyWith(color: primary),
      headlineLarge: AppTypography.headlineLarge.copyWith(color: primary),
      headlineMedium: AppTypography.headlineMedium.copyWith(color: primary),
      headlineSmall: AppTypography.headlineSmall.copyWith(color: primary),
      bodyLarge: AppTypography.bodyLarge.copyWith(color: primary),
      bodyMedium: AppTypography.bodyMedium.copyWith(color: secondary),
      bodySmall: AppTypography.bodySmall.copyWith(color: secondary),
      labelLarge: AppTypography.labelLarge.copyWith(color: primary),
      labelMedium: AppTypography.labelMedium.copyWith(color: secondary),
      labelSmall: AppTypography.labelSmall.copyWith(color: secondary),
    );
  }
}
