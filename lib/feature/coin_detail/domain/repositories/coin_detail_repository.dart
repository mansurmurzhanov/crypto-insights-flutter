import '../entities/coin_detail_entity.dart';

abstract class CoinDetailRepository {
  Future<CoinDetailEntity> getCoinDetail(
    String coinId,
  );
}