import '../../../../core/network/dio_client.dart';
import '../models/coin_chart_point_model.dart';

abstract class CoinChartRemoteDataSource {
  Future<List<CoinChartPointModel>> getChart(
    String coinId,
    int days,
  );
}

class CoinChartRemoteDataSourceImpl
    implements CoinChartRemoteDataSource {
  final DioClient dioClient;

  CoinChartRemoteDataSourceImpl(
    this.dioClient,
  );

  @override
  Future<List<CoinChartPointModel>> getChart(
    String coinId,
    int days,
  ) async {
    final response = await dioClient.dio.get(
      '/coins/$coinId/market_chart',
      queryParameters: {
        'vs_currency': 'usd',
        'days': days,
      },
    );

    final prices =
        response.data['prices'] as List<dynamic>;

    return prices
        .map(
          (e) => CoinChartPointModel.fromJson(
            e,
          ),
        )
        .toList();
  }
}