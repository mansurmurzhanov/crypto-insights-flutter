import 'package:flutter_test/flutter_test.dart';
import 'package:crypto_insights/feature/coin_detail/data/models/coin_detail_model.dart';

void main() {
  test(
    'CoinDetailModel.fromJson parses all fields',
    () {
      final model = CoinDetailModel.fromJson(
        {
          'id': 'bitcoin',
          'name': 'Bitcoin',
          'symbol': 'btc',
          'image': {
            'large': 'image.png',
          },
          'market_cap_rank': 1,
          'market_data': {
            'current_price': {
              'usd': 100000,
            },
            'market_cap': {
              'usd': 2000000,
            },
            'total_volume': {
              'usd': 300000,
            },
            'ath': {
              'usd': 110000,
            },
            'atl': {
              'usd': 1,
            },
          },
        },
      );

      expect(model.id, 'bitcoin');
      expect(model.name, 'Bitcoin');
      expect(model.symbol, 'btc');
      expect(model.image, 'image.png');
      expect(model.currentPrice, 100000);
      expect(model.marketCap, 2000000);
      expect(model.volume, 300000);
      expect(model.marketCapRank, 1);
      expect(model.ath, 110000);
      expect(model.atl, 1);
    },
  );
}