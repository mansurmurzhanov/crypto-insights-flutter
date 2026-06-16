import 'package:flutter_test/flutter_test.dart';
import 'package:crypto_insights/feature/coin_detail/data/models/coin_chart_point_model.dart';

void main() {
  test(
    'CoinChartPointModel.fromJson parses point',
    () {
      final model = CoinChartPointModel.fromJson(
        [
          1704067200000,
          100000,
        ],
      );

      expect(
        model.time,
        DateTime.fromMillisecondsSinceEpoch(
          1704067200000,
        ),
      );

      expect(
        model.price,
        100000,
      );
    },
  );
}