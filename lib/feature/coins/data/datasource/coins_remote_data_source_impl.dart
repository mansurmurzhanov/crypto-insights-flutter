import 'package:injectable/injectable.dart';

import '../../../../core/network/dio_client.dart';
import '../models/coin_model.dart';
import 'coins_remote_data_source.dart';

@LazySingleton(as: CoinsRemoteDataSource)
class CoinsRemoteDataSourceImpl implements CoinsRemoteDataSource {
  final DioClient client;

  List<CoinModel>? _cachedCoins;
  DateTime? _lastFetchTime;

  CoinsRemoteDataSourceImpl(this.client);

  @override
  Future<List<CoinModel>> getCoins({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh &&
        _cachedCoins != null &&
        _lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!) <
            const Duration(seconds: 60)) {
      return _cachedCoins!;
    }

    final response = await client.dio.get(
      '/coins/markets',
      queryParameters: {
        'vs_currency': 'usd',
        'order': 'market_cap_desc',
        'per_page': 100,
        'page': 1,
      },
    );

    final coins = (response.data as List)
        .map((e) => CoinModel.fromJson(e))
        .toList();

    _cachedCoins = coins;
    _lastFetchTime = DateTime.now();

    return coins;
  }
}