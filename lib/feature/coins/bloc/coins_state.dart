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
  final String query;
  final String? error;

  const CoinsState({
    this.status = CoinsStatus.initial,
    this.coins = const [],
    this.query = '',
    this.error,
  });

  CoinsState copyWith({
    CoinsStatus? status,
    List<CoinEntity>? coins,
    String? query,
    String? error,
  }) {
    return CoinsState(
      status: status ?? this.status,
      coins: coins ?? this.coins,
      query: query ?? this.query,
      error: error ?? this.error,
    );
  }
}