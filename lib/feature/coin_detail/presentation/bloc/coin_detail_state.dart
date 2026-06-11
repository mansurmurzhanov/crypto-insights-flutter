import '../../../../core/error/failure.dart';
import '../../domain/entities/coin_detail_entity.dart';

enum CoinDetailStatus { initial, loading, success, failure }

class CoinDetailState {
  final CoinDetailStatus status;
  final CoinDetailEntity? coin;
  final Failure? failure;

  const CoinDetailState({
    this.status = CoinDetailStatus.initial,
    this.coin,
    this.failure,
  });

  CoinDetailState copyWith({
    CoinDetailStatus? status,
    CoinDetailEntity? coin,
    Failure? failure,
  }) {
    return CoinDetailState(
      status: status ?? this.status,
      coin: coin ?? this.coin,
      failure: failure ?? this.failure,
    );
  }
}
