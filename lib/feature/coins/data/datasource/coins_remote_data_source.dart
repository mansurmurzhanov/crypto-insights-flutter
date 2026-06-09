import '../models/coin_model.dart';

abstract interface class CoinsRemoteDataSource {
  Future<List<CoinModel>> getCoins({
    bool forceRefresh = false,
  });
}