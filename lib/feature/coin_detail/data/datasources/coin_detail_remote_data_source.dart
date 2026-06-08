import 'package:injectable/injectable.dart';

import '../../../../core/network/dio_client.dart';

import '../models/coin_detail_model.dart';

abstract class CoinDetailRemoteDataSource {
  Future<CoinDetailModel> getCoinDetail(
    String coinId,
  );
}

@LazySingleton(as: CoinDetailRemoteDataSource)
class CoinDetailRemoteDataSourceImpl
    implements CoinDetailRemoteDataSource {
  final DioClient dioClient;

  final Map<String, CoinDetailModel> _cache = {};
  final Map<String, DateTime> _cacheTime = {};

  CoinDetailRemoteDataSourceImpl(
    this.dioClient,
  );

  @override
  Future<CoinDetailModel> getCoinDetail(
    String coinId,
  ) async {
    if (_cache.containsKey(coinId) &&
        _cacheTime.containsKey(coinId) &&
        DateTime.now().difference(_cacheTime[coinId]!) <
            const Duration(seconds: 60)) {
      return _cache[coinId]!;
    }

    final response = await dioClient.dio.get(
      '/coins/$coinId',
    );

    final coinDetail = CoinDetailModel.fromJson(
      response.data,
    );

    _cache[coinId] = coinDetail;
    _cacheTime[coinId] = DateTime.now();

    return coinDetail;
  }
}