import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeModeCubit extends Cubit<ThemeMode> {
  static const _themeKey = 'theme_mode';

  ThemeModeCubit() : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themeKey);

    switch (savedTheme) {
      case 'light':
        emit(ThemeMode.light);
        break;
      case 'dark':
        emit(ThemeMode.dark);
        break;
      default:
        emit(ThemeMode.system);
    }
  }

  Future<void> setLight() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, 'light');
    emit(ThemeMode.light);
  }

  Future<void> setDark() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, 'dark');
    emit(ThemeMode.dark);
  }

  Future<void> setSystem() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, 'system');
    emit(ThemeMode.system);
  }
}