import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_insights/core/extensions/currency_extension.dart';
import 'package:crypto_insights/core/theme/app_colors.dart';
import 'package:crypto_insights/feature/coins/domain/entities/coin_entity.dart';
import 'package:crypto_insights/feature/coins/presentation/widgets/coin_tile.dart';

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

      expect(
        find.byType(ListTile),
        findsOneWidget,
      );

      expect(
        find.byType(CachedNetworkImage),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'CoinTile image error widget displays bitcoin icon',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CircleAvatar(
              child: Icon(Icons.currency_bitcoin),
            ),
          ),
        ),
      );

      expect(
        find.byType(CircleAvatar),
        findsOneWidget,
      );

      expect(
        find.byIcon(Icons.currency_bitcoin),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'CoinTile displays positive 24h change in green',
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

      expect(
        find.text('5.20%'),
        findsOneWidget,
      );

      final changeText =
          tester.widget<Text>(find.text('5.20%'));

      expect(
        changeText.style?.color,
        AppColors.success,
      );
    },
  );

  testWidgets(
    'CoinTile displays negative 24h change in red',
    (tester) async {
      const coin = CoinEntity(
        id: 'bitcoin',
        symbol: 'btc',
        name: 'Bitcoin',
        image: '',
        currentPrice: 100000,
        priceChange24h: -5.2,
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

      expect(
        find.text('-5.20%'),
        findsOneWidget,
      );

      final changeText =
          tester.widget<Text>(find.text('-5.20%'));

      expect(
        changeText.style?.color,
        AppColors.error,
      );
    },
  );
}