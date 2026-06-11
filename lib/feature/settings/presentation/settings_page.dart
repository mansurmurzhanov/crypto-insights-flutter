import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/bloc/theme_mode/theme_mode_cubit.dart';
import '../../../app/bloc/locale/locale_cubit.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_spacing.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.settings,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.theme,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            BlocBuilder<ThemeModeCubit, ThemeMode>(
              builder: (context, themeMode) {
                return SegmentedButton<ThemeMode>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text(context.l10n.light),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text(context.l10n.dark),
                    ),
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text(context.l10n.system),
                    ),
                  ],
                  selected: {themeMode},
                  onSelectionChanged: (selection) {
                    switch (selection.first) {
                      case ThemeMode.light:
                        context.read<ThemeModeCubit>().setLight();
                        break;
                      case ThemeMode.dark:
                        context.read<ThemeModeCubit>().setDark();
                        break;
                      case ThemeMode.system:
                        context.read<ThemeModeCubit>().setSystem();
                        break;
                    }
                  },
                );
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            const Divider(),
            const SizedBox(height: AppSpacing.lg),
            Text(
              context.l10n.language,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            BlocBuilder<LocaleCubit, Locale?>(
              builder: (context, locale) {
                return SegmentedButton<String>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(
                      value: 'en',
                      label: Text(context.l10n.english),
                    ),
                    ButtonSegment(
                      value: 'ru',
                      label: Text(context.l10n.russian),
                    ),
                  ],
                  selected: {locale?.languageCode ?? 'en'},
                  onSelectionChanged: (selection) {
                    if (selection.first == 'en') {
                      context.read<LocaleCubit>().setEnglish();
                    } else {
                      context.read<LocaleCubit>().setRussian();
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}