abstract class CoinDetailEvent {}

class LoadCoinDetail extends CoinDetailEvent {
  final String coinId;

  LoadCoinDetail(this.coinId);
}

class LoadCoinChart extends CoinDetailEvent {
  final String coinId;
  final int days;

  LoadCoinChart({
    required this.coinId,
    required this.days,
  });
}

class ChangeChartPeriod extends CoinDetailEvent {
  final String coinId;
  final int days;

  ChangeChartPeriod({
    required this.coinId,
    required this.days,
  });
}