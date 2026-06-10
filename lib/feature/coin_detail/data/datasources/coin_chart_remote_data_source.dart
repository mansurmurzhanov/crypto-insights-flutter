import '../../../../core/network/dio_client.dart';
import '../models/coin_chart_point_model.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_mapper.dart';

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

    try {
      final response = await dioClient.dio.get(
        '/coins/$coinId/market_chart',
        queryParameters: {
          'vs_currency': 'usd',
          'days': days,
        },
      );

      final prices = response.data['prices'];

      if (prices == null || prices is! List) {
        throw const ServerFailure(
          'Invalid chart response',
        );
      }

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
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}