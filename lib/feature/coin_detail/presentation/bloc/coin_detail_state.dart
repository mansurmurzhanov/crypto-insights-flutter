import '../../domain/entities/coin_detail_entity.dart';

enum CoinDetailStatus {
  initial,
  loading,
  success,
  failure,
}

class CoinDetailState {
  final CoinDetailStatus status;
  final CoinDetailEntity? coin;
  final String? errorMessage;

  const CoinDetailState({
    this.status = CoinDetailStatus.initial,
    this.coin,
    this.errorMessage,
  });

  CoinDetailState copyWith({
    CoinDetailStatus? status,
    CoinDetailEntity? coin,
    String? errorMessage,
  }) {
    return CoinDetailState(
      status: status ?? this.status,
      coin: coin ?? this.coin,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}