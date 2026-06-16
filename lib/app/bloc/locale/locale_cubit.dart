import 'package:injectable/injectable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class LocaleCubit extends Cubit<Locale?> {
  static const _localeKey = 'locale';

  final SharedPreferences prefs;

  LocaleCubit(this.prefs) : super(null) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final savedLocale = prefs.getString(_localeKey);

    switch (savedLocale) {
      case 'ru':
        emit(const Locale('ru'));
        break;

      case 'en':
        emit(const Locale('en'));
        break;

      default:
        emit(null);
    }
  }

  Future<void> setRussian() async {
    await prefs.setString(_localeKey, 'ru');

    emit(const Locale('ru'));
  }

  Future<void> setEnglish() async {
    await prefs.setString(_localeKey, 'en');

    emit(const Locale('en'));
  }
}