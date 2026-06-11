import '../../../core/error/failure.dart';
import '../domain/entities/coin_entity.dart';

enum CoinsStatus { initial, loading, success, failure }

class CoinsState {
  final CoinsStatus status;
  final List<CoinEntity> coins;
  final String query;
  final Failure? error;
  final String sortBy;
  final int visibleCount;

  const CoinsState({
    this.status = CoinsStatus.initial,
    this.coins = const [],
    this.query = '',
    this.error,
    this.sortBy = 'marketCap',
    this.visibleCount = 20,
  });

  CoinsState copyWith({
    CoinsStatus? status,
    List<CoinEntity>? coins,
    String? query,
    Failure? error,
    String? sortBy,
    int? visibleCount,
    bool clearError = false,
  }) {
    return CoinsState(
      status: status ?? this.status,
      coins: coins ?? this.coins,
      query: query ?? this.query,
      error: clearError ? null : (error ?? this.error),
      sortBy: sortBy ?? this.sortBy,
      visibleCount: visibleCount ?? this.visibleCount,
    );
  }
}
