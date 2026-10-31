import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

/// State representing Theme Configuration
class ThemeState {
  final ThemeMode themeMode;
  final Color primaryColor;

  const ThemeState({
    required this.themeMode,
    required this.primaryColor,
  });

  bool get isDarkMode => themeMode == ThemeMode.dark;

  ThemeState copyWith({
    ThemeMode? themeMode,
    Color? primaryColor,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      primaryColor: primaryColor ?? this.primaryColor,
    );
  }
}

/// ThemeNotifier manages active theme mode and accent color dynamically.
class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier()
      : super(
          const ThemeState(
            themeMode: ThemeMode.light,
            primaryColor: AppColors.primary,
          ),
        ) {
    _loadFromPreferences();
  }

  Future<void> _loadFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedMode = prefs.getString(AppConstants.themeModeKey);
      final savedAccent = prefs.getInt(AppConstants.accentColorKey);

      ThemeMode mode = ThemeMode.light;
      if (savedMode == 'dark') {
        mode = ThemeMode.dark;
      } else if (savedMode == 'system') {
        mode = ThemeMode.system;
      }

      Color accent = AppColors.primary;
      if (savedAccent != null) {
        accent = Color(savedAccent);
      }

      state = state.copyWith(themeMode: mode, primaryColor: accent);
    } catch (_) {
      // Fallback silently to defaults
    }
  }

  /// Toggle between light and dark modes seamlessly
  Future<void> toggleTheme() async {
    final newMode =
        state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }

  /// Explicitly set theme mode (light, dark, system)
  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    try {
      final prefs = await SharedPreferences.getInstance();
      String modeStr = 'light';
      if (mode == ThemeMode.dark) modeStr = 'dark';
      if (mode == ThemeMode.system) modeStr = 'system';
      await prefs.setString(AppConstants.themeModeKey, modeStr);
    } catch (_) {}
  }

  /// Set customized accent color
  Future<void> setAccentColor(Color color) async {
    state = state.copyWith(primaryColor: color);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(AppConstants.accentColorKey, color.toARGB32());
    } catch (_) {}
  }
}

/// Riverpod provider for ThemeState
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});
