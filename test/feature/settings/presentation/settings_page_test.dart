import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:crypto_insights/app/bloc/locale/locale_cubit.dart';
import 'package:crypto_insights/app/bloc/theme_mode/theme_mode_cubit.dart';
import 'package:crypto_insights/feature/settings/presentation/settings_page.dart';
import 'package:crypto_insights/l10n/app_localizations.dart';

void main() {
  testWidgets(
    'SettingsPage renders theme and language sections',
    (tester) async {
      SharedPreferences.setMockInitialValues({});

      final prefs =
          await SharedPreferences.getInstance();

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<ThemeModeCubit>(
              create: (_) => ThemeModeCubit(
                prefs,
              ),
            ),
            BlocProvider<LocaleCubit>(
              create: (_) => LocaleCubit(
                prefs,
              ),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates:
                AppLocalizations.localizationsDelegates,
            supportedLocales:
                AppLocalizations.supportedLocales,
            home: const SettingsPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Theme'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);

      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);
      expect(find.text('System'), findsOneWidget);

      expect(find.text('English'), findsOneWidget);
      expect(find.text('Russian'), findsOneWidget);
    },
  );

  testWidgets(
    'SettingsPage changes theme mode',
    (tester) async {
      SharedPreferences.setMockInitialValues({});

      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<ThemeModeCubit>(
              create: (_) => ThemeModeCubit(prefs),
            ),
            BlocProvider<LocaleCubit>(
              create: (_) => LocaleCubit(prefs),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates:
                AppLocalizations.localizationsDelegates,
            supportedLocales:
                AppLocalizations.supportedLocales,
            home: const SettingsPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      expect(prefs.getString('theme_mode'), 'dark');
    },
  );

  testWidgets(
    'SettingsPage changes locale',
    (tester) async {
      SharedPreferences.setMockInitialValues({});

      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<ThemeModeCubit>(
              create: (_) => ThemeModeCubit(prefs),
            ),
            BlocProvider<LocaleCubit>(
              create: (_) => LocaleCubit(prefs),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates:
                AppLocalizations.localizationsDelegates,
            supportedLocales:
                AppLocalizations.supportedLocales,
            home: const SettingsPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Russian'));
      await tester.pumpAndSettle();

      expect(prefs.getString('locale'), 'ru');
    },
  );

  testWidgets(
    'SettingsPage changes theme mode to light',
    (tester) async {
      SharedPreferences.setMockInitialValues({
        'theme_mode': 'dark',
      });

      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<ThemeModeCubit>(
              create: (_) => ThemeModeCubit(prefs),
            ),
            BlocProvider<LocaleCubit>(
              create: (_) => LocaleCubit(prefs),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates:
                AppLocalizations.localizationsDelegates,
            supportedLocales:
                AppLocalizations.supportedLocales,
            home: const SettingsPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Light'));
      await tester.pumpAndSettle();

      expect(prefs.getString('theme_mode'), 'light');
    },
  );

  testWidgets(
    'SettingsPage changes locale to english',
    (tester) async {
      SharedPreferences.setMockInitialValues({
        'locale': 'ru',
      });

      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<ThemeModeCubit>(
              create: (_) => ThemeModeCubit(prefs),
            ),
            BlocProvider<LocaleCubit>(
              create: (_) => LocaleCubit(prefs),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates:
                AppLocalizations.localizationsDelegates,
            supportedLocales:
                AppLocalizations.supportedLocales,
            home: const SettingsPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();

      expect(prefs.getString('locale'), 'en');
    },
  );
}