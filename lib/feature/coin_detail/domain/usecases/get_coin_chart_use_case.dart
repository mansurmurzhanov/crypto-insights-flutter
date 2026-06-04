import '../entities/coin_chart_point_entity.dart';
import '../repositories/coin_chart_repository.dart';

class GetCoinChartUseCase {
  final CoinChartRepository repository;

  GetCoinChartUseCase(
    this.repository,
  );

  Future<List<CoinChartPointEntity>> call(
    String coinId,
    int days,
  ) {
    return repository.getChart(
      coinId,
      days,
    );
  }
}
