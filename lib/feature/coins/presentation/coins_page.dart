import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import '../../../l10n/app_localizations.dart';

@RoutePage()

class CoinsPage extends StatelessWidget {
  const CoinsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(AppLocalizations.of(context)!.hello),
      ),
    );
    
  }
}