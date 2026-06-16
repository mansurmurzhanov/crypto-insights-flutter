import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:crypto_insights/app/bloc/locale/locale_cubit.dart';

class MockSharedPreferences extends Mock
    implements SharedPreferences {}

void main() {
  late MockSharedPreferences prefs;

  setUp(() {
    prefs = MockSharedPreferences();
  });

  test(
    'loads russian locale from preferences',
    () async {
      when(
        () => prefs.getString('locale'),
      ).thenReturn('ru');

      final cubit = LocaleCubit(prefs);

      await Future<void>.delayed(
        Duration.zero,
      );

      expect(
        cubit.state,
        const Locale('ru'),
      );
    },
  );

  test(
    'loads english locale from preferences',
    () async {
      when(
        () => prefs.getString('locale'),
      ).thenReturn('en');

      final cubit = LocaleCubit(prefs);

      await Future<void>.delayed(
        Duration.zero,
      );

      expect(
        cubit.state,
        const Locale('en'),
      );
    },
  );

  test(
    'setRussian saves locale and emits ru',
    () async {
      when(
        () => prefs.setString(
          'locale',
          'ru',
        ),
      ).thenAnswer((_) async => true);

      when(
        () => prefs.getString(any()),
      ).thenReturn(null);

      final cubit = LocaleCubit(prefs);

      await cubit.setRussian();

      verify(
        () => prefs.setString(
          'locale',
          'ru',
        ),
      ).called(1);

      expect(
        cubit.state,
        const Locale('ru'),
      );
    },
  );

  test(
    'setEnglish saves locale and emits en',
    () async {
      when(
        () => prefs.setString(
          'locale',
          'en',
        ),
      ).thenAnswer((_) async => true);

      when(
        () => prefs.getString(any()),
      ).thenReturn(null);

      final cubit = LocaleCubit(prefs);

      await cubit.setEnglish();

      verify(
        () => prefs.setString(
          'locale',
          'en',
        ),
      ).called(1);

      expect(
        cubit.state,
        const Locale('en'),
      );
    },
  );
}