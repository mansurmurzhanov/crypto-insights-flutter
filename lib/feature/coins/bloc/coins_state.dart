import '../domain/entities/coin_entity.dart';

enum CoinsStatus {
  initial,
  loading,
  success,
  failure,
}

class CoinsState {
  final CoinsStatus status;
  final List<CoinEntity> coins;
  final String? error;

  const CoinsState({
    this.status = CoinsStatus.initial,
    this.coins = const [],
    this.error,
  });

  CoinsState copyWith({
    CoinsStatus? status,
    List<CoinEntity>? coins,
    String? error,
  }) {
    return CoinsState(
      status: status ?? this.status,
      coins: coins ?? this.coins,
      error: error ?? this.error,
    );
  }
}