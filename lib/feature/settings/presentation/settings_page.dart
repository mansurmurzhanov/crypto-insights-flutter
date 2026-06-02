import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/bloc/theme_mode/theme_mode_cubit.dart';
import '../../../l10n/app_localizations.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(AppLocalizations.of(context)!.hello,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<ThemeModeCubit>().setLight();
              },
              child: const Text('Light'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                context.read<ThemeModeCubit>().setDark();
              },
              child: const Text('Dark'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                context.read<ThemeModeCubit>().setSystem();
              },
              child: const Text('System'),
            ),
          ],
        ),
      ),
    );
  }
}