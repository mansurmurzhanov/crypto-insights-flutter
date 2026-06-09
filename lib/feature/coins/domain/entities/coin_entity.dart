class CoinEntity {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final double currentPrice;
  final double priceChange24h;
  final int marketCapRank;

  const CoinEntity({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.priceChange24h,
    required this.marketCapRank,
  });
}