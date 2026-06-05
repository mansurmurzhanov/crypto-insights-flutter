import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/bloc/theme_mode/theme_mode_cubit.dart';
import '../../../app/bloc/locale/locale_cubit.dart';
import '../../../l10n/app_localizations.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.settings,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<ThemeModeCubit>().setLight();
              },
              child: Text(
                AppLocalizations.of(context)!.light,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                context.read<ThemeModeCubit>().setDark();
              },
              child: Text(
                AppLocalizations.of(context)!.dark,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                context.read<ThemeModeCubit>().setSystem();
              },
              child: Text(
                AppLocalizations.of(context)!.system,
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<LocaleCubit>().setEnglish();
              },
              child: Text(
                AppLocalizations.of(context)!.english,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                context.read<LocaleCubit>().setRussian();
              },
              child: Text(
                AppLocalizations.of(context)!.russian,
              ),
            ),
          ],
        ),
      ),
    );
  }
}