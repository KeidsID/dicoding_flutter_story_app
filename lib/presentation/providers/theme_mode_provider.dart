import 'package:flutter/material.dart';

import '../../data/cache/theme_mode_preferences.dart';

class ThemeModeProvider extends ChangeNotifier {
  final ThemeModePreferences _themeModePreferences;

  ThemeModeProvider({required ThemeModePreferences themeModePreferences})
      : _themeModePreferences = themeModePreferences {
    _fetchThemeModeFromCache();
  }

  Future<void> _fetchThemeModeFromCache() async {
    final themeModeFromCache = await _themeModePreferences.getThemeMode();

    _themeMode = themeModeFromCache;
    notifyListeners();
  }

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;
  setThemeMode(ThemeMode value) async {
    await _themeModePreferences.saveThemeMode(value);
    _themeMode = value;
    notifyListeners();
  }
}
