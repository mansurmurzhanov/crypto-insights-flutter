import 'package:injectable/injectable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/usecases/get_coins_use_case.dart';
import 'coins_event.dart';
import 'coins_state.dart';

@injectable
class CoinsBloc extends Bloc<CoinsEvent, CoinsState> {
  final GetCoinsUseCase getCoinsUseCase;

  CoinsBloc(this.getCoinsUseCase)
      : super(const CoinsState()) {
    on<LoadCoins>(_onLoadCoins);
    on<RefreshCoins>(_onRefreshCoins);
    on<SearchCoins>(_onSearchCoins);
    on<SortCoins>(_onSortCoins);
    on<LoadMoreCoins>(_onLoadMoreCoins);
  }

  Future<void> _onLoadCoins(
  LoadCoins event,
  Emitter<CoinsState> emit,
) async {
  emit(
    state.copyWith(
      status: CoinsStatus.loading,
    ),
  );

  

  try {
    final coins = await getCoinsUseCase();

    emit(
      state.copyWith(
        status: CoinsStatus.success,
        coins: coins,
        visibleCount: 20,
        clearError: true,
      ),
    );
  } catch (e) {
    String message = 'somethingWentWrong';

    final error = e.toString().toLowerCase();

    if (error.contains('connection') ||
        error.contains('socket') ||
        error.contains('network')) {
      message = 'noInternetConnection';
    }

    emit(
      state.copyWith(
        status: CoinsStatus.failure,
        error: message,
      ),
    );
  }
}

Future<void> _onRefreshCoins(
  RefreshCoins event,
  Emitter<CoinsState> emit,
) async {
  emit(
    state.copyWith(
      status: CoinsStatus.loading,
    ),
  );

  try {
    final coins = await getCoinsUseCase(
      forceRefresh: true,
    );

    emit(
      state.copyWith(
        status: CoinsStatus.success,
        coins: coins,
        visibleCount: 20,
        clearError: true,
      ),
    );
  } catch (e) {
    String message = 'somethingWentWrong';

    final error = e.toString().toLowerCase();

    if (error.contains('connection') ||
        error.contains('socket') ||
        error.contains('network')) {
      message = 'noInternetConnection';
    }

    emit(
      state.copyWith(
        status: CoinsStatus.failure,
        error: message,
      ),
    );
  }
}
  void _onSearchCoins(
    SearchCoins event,
    Emitter<CoinsState> emit,
  ) {
    emit(
      state.copyWith(
        query: event.query,
      ),
    );
  }

  void _onSortCoins(
    SortCoins event,
    Emitter<CoinsState> emit,
  ) {
    final sortedCoins = List.of(state.coins);

    switch (event.sortBy) {
      case 'marketCap':
        sortedCoins.sort(
          (a, b) => a.marketCapRank.compareTo(b.marketCapRank),
        );
        break;
      case 'change24hDesc':
        sortedCoins.sort(
          (a, b) => b.priceChange24h.compareTo(a.priceChange24h),
        );
        break;

      case 'change24hAsc':
        sortedCoins.sort(
          (a, b) => a.priceChange24h.compareTo(b.priceChange24h),
        );
        break;

      default:
        break;
    }

    emit(
      state.copyWith(
        coins: sortedCoins,
        sortBy: event.sortBy,
      ),
    );
  }

  void _onLoadMoreCoins(
    LoadMoreCoins event,
    Emitter<CoinsState> emit,
  ) {
    if (state.visibleCount >= state.coins.length) {
      return;
    }

    emit(
      state.copyWith(
        visibleCount: (state.visibleCount + 20)
            .clamp(0, state.coins.length),
      ),
    );
  }
}