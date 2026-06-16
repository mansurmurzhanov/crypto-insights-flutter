import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@injectable
class ThemeModeCubit extends Cubit<ThemeMode> {
  static const _themeKey = 'theme_mode';

  final SharedPreferences prefs;

  ThemeModeCubit(this.prefs) : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
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
    await prefs.setString(_themeKey, 'light');
    emit(ThemeMode.light);
  }

  Future<void> setDark() async {
    await prefs.setString(_themeKey, 'dark');
    emit(ThemeMode.dark);
  }

  Future<void> setSystem() async {
    await prefs.setString(_themeKey, 'system');
    emit(ThemeMode.system);
  }
}