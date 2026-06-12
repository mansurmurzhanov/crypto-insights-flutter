import '../../../../core/error/failure.dart';
import '../../domain/entities/coin_chart_point_entity.dart';
import '../../domain/entities/coin_detail_entity.dart';

enum CoinDetailStatus {
  initial,
  loading,
  success,
  failure,
}

enum CoinChartStatus {
  initial,
  loading,
  success,
  failure,
}

class CoinDetailState {
  final CoinDetailStatus status;
  final CoinDetailEntity? coin;
  final Failure? failure;

  final CoinChartStatus chartStatus;
  final List<CoinChartPointEntity> points;
  final String? chartErrorMessage;
  final int selectedDays;

  const CoinDetailState({
    this.status = CoinDetailStatus.initial,
    this.coin,
    this.failure,
    this.chartStatus = CoinChartStatus.initial,
    this.points = const [],
    this.chartErrorMessage,
    this.selectedDays = 1,
  });

  CoinDetailState copyWith({
    CoinDetailStatus? status,
    CoinDetailEntity? coin,
    Failure? failure,
    CoinChartStatus? chartStatus,
    List<CoinChartPointEntity>? points,
    String? chartErrorMessage,
    int? selectedDays,
  }) {
    return CoinDetailState(
      status: status ?? this.status,
      coin: coin ?? this.coin,
      failure: failure ?? this.failure,
      chartStatus: chartStatus ?? this.chartStatus,
      points: points ?? this.points,
      chartErrorMessage:
          chartErrorMessage ?? this.chartErrorMessage,
      selectedDays: selectedDays ?? this.selectedDays,
    );
  }
}