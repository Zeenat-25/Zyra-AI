import 'package:flutter/material.dart';
import '../services/preferences_service.dart';
import '../constants/app_constants.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final isDark = await PreferencesService.getBool(AppConstants.prefKeyTheme);
    if (isDark == true) {
      _themeMode = ThemeMode.dark;
      notifyListeners();
    }
  }

  Future<void> toggleTheme() async {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    await PreferencesService.setBool(
      AppConstants.prefKeyTheme,
      isDarkMode,
    );
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await PreferencesService.setBool(
      AppConstants.prefKeyTheme,
      mode == ThemeMode.dark,
    );
    notifyListeners();
  }
}
