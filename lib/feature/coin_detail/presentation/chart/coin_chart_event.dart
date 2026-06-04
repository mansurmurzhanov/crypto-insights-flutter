abstract class CoinChartEvent {}

class LoadCoinChart extends CoinChartEvent {
  final String coinId;
  final int days;

  LoadCoinChart({
    required this.coinId,
    required this.days,
  });
}

class ChangeChartPeriod extends CoinChartEvent {
  final String coinId;
  final int days;

  ChangeChartPeriod({
    required this.coinId,
    required this.days,
  });
}