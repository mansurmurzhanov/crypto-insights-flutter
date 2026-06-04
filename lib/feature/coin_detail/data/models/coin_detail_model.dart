import '../../domain/entities/coin_detail_entity.dart';

class CoinDetailModel extends CoinDetailEntity {
  const CoinDetailModel({
    required super.id,
    required super.name,
    required super.symbol,
    required super.image,
    required super.currentPrice,
    required super.marketCap,
    required super.volume,
    required super.marketCapRank,
    required super.ath,
    required super.atl,
  });

  factory CoinDetailModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CoinDetailModel(
      id: json['id'] as String,
      name: json['name'] as String,
      symbol: json['symbol'] as String,

      image: json['image']['large'] as String,

      currentPrice:
          (json['market_data']['current_price']['usd'] as num)
              .toDouble(),

      marketCap:
          (json['market_data']['market_cap']['usd'] as num)
              .toDouble(),

      volume:
          (json['market_data']['total_volume']['usd'] as num)
              .toDouble(),

      marketCapRank:
          (json['market_cap_rank'] as num).toInt(),

      ath:
          (json['market_data']['ath']['usd'] as num)
              .toDouble(),

      atl:
          (json['market_data']['atl']['usd'] as num)
              .toDouble(),
    );
  }
}