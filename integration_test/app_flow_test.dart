import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:crypto_insights/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('full app flow', (tester) async {
    app.main();

    await tester.pumpAndSettle(
      const Duration(seconds: 8),
    );

    await tester.pump(
      const Duration(seconds: 3),
    );

    expect(
      find.byKey(const Key('search_field')),
      findsOneWidget,
    );

    await tester.tap(
      find.byType(ListTile).first,
    );

    await tester.pumpAndSettle(
      const Duration(seconds: 5),
    );

    expect(
      find.byKey(const Key('period_1')),
      findsOneWidget,
    );

    await tester.tap(
      find.byKey(const Key('period_7')),
    );

    await tester.pumpAndSettle(
      const Duration(seconds: 2),
    );

    await tester.tap(
      find.byKey(const Key('period_30')),
    );

    await tester.pumpAndSettle(
      const Duration(seconds: 2),
    );

    await tester.tap(
      find.byKey(const Key('favorite_button')),
    );

    await tester.pumpAndSettle();

    expect(
      find.byType(BackButton),
      findsOneWidget,
    );

    await tester.tap(
      find.byType(BackButton),
    );

    await tester.pumpAndSettle(
      const Duration(seconds: 2),
    );

    await tester.tap(
      find.byKey(const Key('favorites_button')),
    );

    await tester.pumpAndSettle(
      const Duration(seconds: 5),
    );

    expect(
      find.byIcon(Icons.delete_outline),
      findsWidgets,
    );
  });
}