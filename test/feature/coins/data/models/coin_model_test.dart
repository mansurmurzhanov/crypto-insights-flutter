import 'package:flutter_test/flutter_test.dart';
import 'package:crypto_insights/feature/coins/data/models/coin_model.dart';

void main() {
  test(
    'CoinModel.fromJson parses all fields',
    () {
      final model = CoinModel.fromJson(
        {
          'id': 'bitcoin',
          'symbol': 'btc',
          'name': 'Bitcoin',
          'image': 'image.png',
          'current_price': 100000,
          'price_change_percentage_24h': 5.2,
          'market_cap_rank': 1,
        },
      );

      expect(model.id, 'bitcoin');
      expect(model.symbol, 'btc');
      expect(model.name, 'Bitcoin');
      expect(model.image, 'image.png');
      expect(model.currentPrice, 100000);
      expect(model.priceChange24h, 5.2);
      expect(model.marketCapRank, 1);
    },
  );

  test(
    'CoinModel uses fallback values',
    () {
      final model = CoinModel.fromJson(
        {
          'id': 'bitcoin',
          'symbol': 'btc',
          'name': 'Bitcoin',
          'image': 'image.png',
          'current_price': 100000,
        },
      );

      expect(model.priceChange24h, 0);
      expect(model.marketCapRank, 999999);
    },
  );
}