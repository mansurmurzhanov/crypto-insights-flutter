import '../../domain/entities/coin_chart_point_entity.dart';

class CoinChartPointModel extends CoinChartPointEntity {
  const CoinChartPointModel({
    required super.time,
    required super.price,
  });

  factory CoinChartPointModel.fromJson(
    List<dynamic> json,
  ) {
    return CoinChartPointModel(
      time: DateTime.fromMillisecondsSinceEpoch(
        json[0] as int,
      ),
      price: (json[1] as num).toDouble(),
    );
  }
}