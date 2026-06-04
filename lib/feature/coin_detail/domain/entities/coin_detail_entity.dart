class CoinDetailEntity {
  final String id;
  final String name;
  final String symbol;
  final String image;

  final double currentPrice;
  final double marketCap;
  final double volume;

  final int marketCapRank;

  final double ath;
  final double atl;

  const CoinDetailEntity({
    required this.id,
    required this.name,
    required this.symbol,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    required this.volume,
    required this.marketCapRank,
    required this.ath,
    required this.atl,
  });
}