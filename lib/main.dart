import 'app/router/router_provider.dart';

import 'package:flutter/material.dart';

import 'app/di/injection.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/bloc/theme_mode/theme_mode_cubit.dart';
import 'app/bloc/locale/locale_cubit.dart';
import 'core/theme/app_theme.dart';

import 'feature/coins/bloc/coins_bloc.dart';

import 'l10n/app_localizations.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();

  runApp(
MultiBlocProvider(
  providers: [
    BlocProvider(
      create: (_) => getIt<ThemeModeCubit>(),
    ),
    BlocProvider(
      create: (_) => getIt<LocaleCubit>(),
    ),

    BlocProvider(
      create: (_) => getIt<CoinsBloc>(),
    ),
  ],
  child: const CryptoInsightsApp(),
)
);
}

class CryptoInsightsApp extends StatelessWidget {
  const CryptoInsightsApp({super.key});

  @override
Widget build(BuildContext context) {
  return BlocBuilder<ThemeModeCubit, ThemeMode>(
    builder: (context, themeMode) {
      return MaterialApp.router(
        routerConfig: appRouter.config(),
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeMode,
        locale: context.watch<LocaleCubit>().state,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      );
    },
  );
}
}
