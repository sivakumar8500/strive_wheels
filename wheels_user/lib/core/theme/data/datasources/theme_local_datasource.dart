import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ThemeLocalDataSource {
  Future<ThemeMode> getSavedThemeMode();
  Future<void> saveThemeMode(ThemeMode themeMode);
}

class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  static const String themePreferenceKey = 'user_theme_mode';
  final SharedPreferences? sharedPreferences;

  ThemeLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<ThemeMode> getSavedThemeMode() async {
    if (sharedPreferences == null) return ThemeMode.system;
    final String? themeStr = sharedPreferences!.getString(themePreferenceKey);
    if (themeStr == 'light') {
      return ThemeMode.light;
    } else if (themeStr == 'dark') {
      return ThemeMode.dark;
    }
    return ThemeMode.system;
  }

  @override
  Future<void> saveThemeMode(ThemeMode themeMode) async {
    if (sharedPreferences == null) return;
    final String themeStr = switch (themeMode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await sharedPreferences!.setString(themePreferenceKey, themeStr);
  }
}
