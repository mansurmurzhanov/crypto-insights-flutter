import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_insights/core/extensions/currency_extension.dart';
import 'package:crypto_insights/core/theme/app_colors.dart';
import 'package:crypto_insights/feature/coins/domain/entities/coin_entity.dart';
import 'package:crypto_insights/feature/coins/presentation/widgets/coin_tile.dart';
import 'package:auto_route/auto_route.dart';
import 'package:mocktail/mocktail.dart';

class FakePageRouteInfo extends Fake
    implements PageRouteInfo<dynamic> {}

class MockStackRouter extends Mock implements StackRouter {}

void main() {
  late MockStackRouter router;

  setUpAll(() {
    registerFallbackValue(FakePageRouteInfo());
  });

  setUp(() {
    router = MockStackRouter();
    when(() => router.push<Object?>(any())).thenAnswer((_) async => null);
  });

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

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CoinTile(
                coin: coin,
              ),
            ),
          ),
        );
      });

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

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CoinTile(
                coin: coin,
              ),
            ),
          ),
        );
      });

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

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CoinTile(
                coin: coin,
              ),
            ),
          ),
        );
      });

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
  testWidgets(
    'CoinTile displays formatted price and percentage',
    (tester) async {
      const coin = CoinEntity(
        id: 'bitcoin',
        symbol: 'btc',
        name: 'Bitcoin',
        image: '',
        currentPrice: 12345,
        priceChange24h: 1.5,
        marketCapRank: 1,
      );

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CoinTile(
                coin: coin,
              ),
            ),
          ),
        );
      });

      expect(
        find.text(coin.currentPrice.formattedCurrency()),
        findsOneWidget,
      );

      expect(find.text('1.50%'), findsOneWidget);
    },
  );

  testWidgets(
    'CoinTile navigates to detail page on tap',
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

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: StackRouterScope(
              controller: router,
              stateHash: 0,
              child: Scaffold(
                body: CoinTile(coin: coin),
              ),
            ),
          ),
        );
      });

      await tester.tap(find.byType(ListTile));
      await tester.pump();

      verify(() => router.push<Object?>(any())).called(1);
    },
  );

  testWidgets(
    'CoinTile shows placeholder while image loading',
    (tester) async {
      const coin = CoinEntity(
        id: 'bitcoin',
        symbol: 'btc',
        name: 'Bitcoin',
        image: 'https://example.com/image.png',
        currentPrice: 100000,
        priceChange24h: 5.2,
        marketCapRank: 1,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CoinTile(coin: coin),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );
}