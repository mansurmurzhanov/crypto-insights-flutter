import 'package:injectable/injectable.dart';
import '../../domain/entities/coin_chart_point_entity.dart';
import '../../domain/repositories/coin_chart_repository.dart';
import '../datasources/coin_chart_remote_data_source.dart';

@LazySingleton(as: CoinChartRepository)
class CoinChartRepositoryImpl
    implements CoinChartRepository {
  final CoinChartRemoteDataSource remoteDataSource;

  CoinChartRepositoryImpl(
    this.remoteDataSource,
  );

  @override
  Future<List<CoinChartPointEntity>> getChart(
    String coinId,
    int days,
  ) {
    return remoteDataSource.getChart(
      coinId,
      days,
    );
  }
}