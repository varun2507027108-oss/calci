import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Theme mode provider — controls dark/light/system theme.
///
/// Persists user preference in Hive settings box.
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(_loadSavedTheme());

  static ThemeMode _loadSavedTheme() {
    final box = Hive.box('settings');
    final saved = box.get('themeMode', defaultValue: 'dark');
    switch (saved) {
      case 'light':
        return ThemeMode.light;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.dark;
    }
  }

  void setTheme(ThemeMode mode) {
    state = mode;
    final box = Hive.box('settings');
    switch (mode) {
      case ThemeMode.light:
        box.put('themeMode', 'light');
      case ThemeMode.dark:
        box.put('themeMode', 'dark');
      case ThemeMode.system:
        box.put('themeMode', 'system');
    }
  }

  void toggleTheme() {
    if (state == ThemeMode.dark) {
      setTheme(ThemeMode.light);
    } else {
      setTheme(ThemeMode.dark);
    }
  }
}
