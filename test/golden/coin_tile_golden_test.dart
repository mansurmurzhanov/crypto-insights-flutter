import 'package:crypto_insights/feature/coins/domain/entities/coin_entity.dart';
import 'package:crypto_insights/feature/coins/presentation/widgets/coin_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  testGoldens('CoinTile light', (tester) async {
    final coin = CoinEntity(
      id: 'bitcoin',
      symbol: 'btc',
      name: 'Bitcoin',
      image: '',
      currentPrice: 50000,
      priceChange24h: 5.25,
      marketCapRank: 1,
    );

    await tester.pumpWidgetBuilder(
      MaterialApp(
        home: Scaffold(
          body: CoinTile(coin: coin),
        ),
      ),
    );

    await tester.pump();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile(
        '../goldens/coin_tile_light.png',
      ),
    );
  });
    testGoldens('CoinTile dark', (tester) async {
    final coin = CoinEntity(
      id: 'bitcoin',
      symbol: 'btc',
      name: 'Bitcoin',
      image: '',
      currentPrice: 50000,
      priceChange24h: 5.25,
      marketCapRank: 1,
    );

    await tester.pumpWidgetBuilder(
      MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
          body: CoinTile(coin: coin),
        ),
      ),
    );

    await tester.pump();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile(
        '../goldens/coin_tile_dark.png',
      ),
    );
  });
}