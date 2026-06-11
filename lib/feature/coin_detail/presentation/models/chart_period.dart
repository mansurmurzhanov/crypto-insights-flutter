enum ChartPeriod {
  day(label: '24H', days: 1),
  week(label: '7D', days: 7),
  month(label: '30D', days: 30);

  const ChartPeriod({required this.label, required this.days});

  final String label;
  final int days;
}
