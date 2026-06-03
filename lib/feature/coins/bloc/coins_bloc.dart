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
      ),
    );
  } catch (e) {
    emit(
      state.copyWith(
        status: CoinsStatus.failure,
        error: e.toString(),
      ),
    );
  }
}

  Future<void> _onRefreshCoins(
    RefreshCoins event,
    Emitter<CoinsState> emit,
  ) async {
    await _onLoadCoins(
      LoadCoins(),
      emit,
    );
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
}