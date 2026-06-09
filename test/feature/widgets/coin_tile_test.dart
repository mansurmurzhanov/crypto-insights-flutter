import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:crypto_insights/feature/coins/domain/entities/coin_entity.dart';
import 'package:crypto_insights/feature/coins/presentation/widgets/coin_tile.dart';
import 'package:crypto_insights/core/extensions/currency_extension.dart';

void main() {
  testWidgets(
    'CoinTile displays coin name and symbol',
    (tester) async {
      const coin = CoinEntity(
        id: 'bitcoin',
        symbol: 'btc',
        name: 'Bitcoin',
        image: '',
        currentPrice: 100000,
        priceChange24h: 5.2,
        marketCapRank: 1,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CoinTile(
              coin: coin,
            ),
          ),
        ),
      );

      expect(find.text('Bitcoin'), findsOneWidget);
      expect(find.text('BTC'), findsOneWidget);
      expect(
        find.text(coin.currentPrice.formattedCurrency()),
        findsOneWidget,
      );
      
    },
  );
}