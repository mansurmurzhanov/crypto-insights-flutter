import '../../../../core/network/dio_client.dart';
import '../models/coin_chart_point_model.dart';
import 'package:injectable/injectable.dart';

abstract class CoinChartRemoteDataSource {
  Future<List<CoinChartPointModel>> getChart(
    String coinId,
    int days,
  );
}

@LazySingleton(as: CoinChartRemoteDataSource)
class CoinChartRemoteDataSourceImpl
    implements CoinChartRemoteDataSource {
  final DioClient dioClient;
  final Map<String, List<CoinChartPointModel>> _cache = {};
  final Map<String, DateTime> _cacheTime = {};

  CoinChartRemoteDataSourceImpl(
    this.dioClient,
  );

  @override
  Future<List<CoinChartPointModel>> getChart(
    String coinId,
    int days,
  ) async {
    final cacheKey = '${coinId}_$days';

    if (_cache.containsKey(cacheKey) &&
        _cacheTime.containsKey(cacheKey) &&
        DateTime.now().difference(_cacheTime[cacheKey]!) <
            const Duration(seconds: 60)) {
      return _cache[cacheKey]!;
    }

    final response = await dioClient.dio.get(
      '/coins/$coinId/market_chart',
      queryParameters: {
        'vs_currency': 'usd',
        'days': days,
      },
    );

    final prices =
        response.data['prices'] as List<dynamic>;

    final chartPoints = prices
        .map(
          (e) => CoinChartPointModel.fromJson(
            e,
          ),
        )
        .toList();

    _cache[cacheKey] = chartPoints;
    _cacheTime[cacheKey] = DateTime.now();

    return chartPoints;
  }
}