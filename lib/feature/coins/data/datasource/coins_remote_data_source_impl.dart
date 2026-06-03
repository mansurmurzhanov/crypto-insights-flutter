import 'package:injectable/injectable.dart';

import '../../../../core/network/dio_client.dart';
import '../models/coin_model.dart';
import 'coins_remote_data_source.dart';

@LazySingleton(as: CoinsRemoteDataSource)
class CoinsRemoteDataSourceImpl implements CoinsRemoteDataSource {
  final DioClient client;

  CoinsRemoteDataSourceImpl(this.client);

  @override
  Future<List<CoinModel>> getCoins() async {
    final response = await client.dio.get(
      '/coins/markets',
      queryParameters: {
        'vs_currency': 'usd',
        'order': 'market_cap_desc',
        'per_page': 100,
        'page': 1,
      },
    );

    return (response.data as List)
        .map((e) => CoinModel.fromJson(e))
        .toList();
  }
}