import '../entities/coin_entity.dart';

abstract interface class CoinsRepository {
  Future<List<CoinEntity>> getCoins();
}