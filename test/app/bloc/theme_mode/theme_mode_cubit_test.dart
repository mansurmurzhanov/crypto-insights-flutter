import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:crypto_insights/app/bloc/theme_mode/theme_mode_cubit.dart';

class MockSharedPreferences extends Mock
    implements SharedPreferences {}

void main() {
  late MockSharedPreferences prefs;

  setUp(() {
    prefs = MockSharedPreferences();
  });

  test(
    'loads light theme from preferences',
    () async {
      when(
        () => prefs.getString('theme_mode'),
      ).thenReturn('light');

      final cubit = ThemeModeCubit(prefs);

      await Future<void>.delayed(Duration.zero);

      expect(
        cubit.state,
        ThemeMode.light,
      );
    },
  );

  test(
    'loads dark theme from preferences',
    () async {
      when(
        () => prefs.getString('theme_mode'),
      ).thenReturn('dark');

      final cubit = ThemeModeCubit(prefs);

      await Future<void>.delayed(Duration.zero);

      expect(
        cubit.state,
        ThemeMode.dark,
      );
    },
  );

  test(
    'setLight saves theme and emits light',
    () async {
      when(
        () => prefs.setString(
          'theme_mode',
          'light',
        ),
      ).thenAnswer((_) async => true);

      when(
        () => prefs.getString(any()),
      ).thenReturn(null);

      final cubit = ThemeModeCubit(prefs);

      await cubit.setLight();

      verify(
        () => prefs.setString(
          'theme_mode',
          'light',
        ),
      ).called(1);

      expect(
        cubit.state,
        ThemeMode.light,
      );
    },
  );

  test(
    'setDark saves theme and emits dark',
    () async {
      when(
        () => prefs.setString(
          'theme_mode',
          'dark',
        ),
      ).thenAnswer((_) async => true);

      when(
        () => prefs.getString(any()),
      ).thenReturn(null);

      final cubit = ThemeModeCubit(prefs);

      await cubit.setDark();

      verify(
        () => prefs.setString(
          'theme_mode',
          'dark',
        ),
      ).called(1);

      expect(
        cubit.state,
        ThemeMode.dark,
      );
    },
  );

  test(
    'setSystem saves theme and emits system',
    () async {
      when(
        () => prefs.setString(
          'theme_mode',
          'system',
        ),
      ).thenAnswer((_) async => true);

      when(
        () => prefs.getString(any()),
      ).thenReturn(null);

      final cubit = ThemeModeCubit(prefs);

      await cubit.setSystem();

      verify(
        () => prefs.setString(
          'theme_mode',
          'system',
        ),
      ).called(1);

      expect(
        cubit.state,
        ThemeMode.system,
      );
    },
  );
}