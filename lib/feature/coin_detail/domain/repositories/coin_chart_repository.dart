import '../entities/coin_chart_point_entity.dart';

abstract class CoinChartRepository {
  Future<List<CoinChartPointEntity>> getChart(
    String coinId,
    int days,
  );
}