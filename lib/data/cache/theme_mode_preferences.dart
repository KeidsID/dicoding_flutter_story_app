import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service that handles [ThemeMode] for app.
class ThemeModePreferences {
  final SharedPreferences sharedPreferences;

  const ThemeModePreferences(this.sharedPreferences);

  static const _prefKey = 'app.themeMode';

  Future<bool> saveThemeMode(ThemeMode themeMode) {
    return sharedPreferences.setInt(
      _prefKey,
      ThemeMode.values.indexOf(themeMode),
    );
  }

  Future<ThemeMode> getThemeMode() async {
    await sharedPreferences.reload();

    final themeModeIndex = sharedPreferences.getInt(_prefKey) ?? 0;

    return ThemeMode.values[themeModeIndex];
  }
}
