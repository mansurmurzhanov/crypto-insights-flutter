import '../../domain/entities/coin_entity.dart';

class CoinModel extends CoinEntity {
  const CoinModel({
    required super.id,
    required super.symbol,
    required super.name,
    required super.image,
    required super.currentPrice,
    required super.priceChange24h,
  });

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      currentPrice: (json['current_price'] as num).toDouble(),
      priceChange24h:
          (json['price_change_percentage_24h'] as num?)?.toDouble() ?? 0,
    );
  }
}