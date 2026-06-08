import '../../domain/entities/coin_chart_point_entity.dart';

enum CoinChartStatus {
  initial,
  loading,
  success,
  failure,
}

class CoinChartState {
  final CoinChartStatus status;
  final List<CoinChartPointEntity> points;
  final String? errorMessage;
  final int selectedDays;

  const CoinChartState({
    this.status = CoinChartStatus.initial,
    this.points = const [],
    this.errorMessage,
    this.selectedDays = 1,
  });

  CoinChartState copyWith({
    CoinChartStatus? status,
    List<CoinChartPointEntity>? points,
    String? errorMessage,
    int? selectedDays,
  }) {
    return CoinChartState(
      status: status ?? this.status,
      points: points ?? this.points,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedDays: selectedDays ?? this.selectedDays,
    );
  }
}