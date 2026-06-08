import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/get_coin_detail_use_case.dart';
import 'coin_detail_event.dart';
import 'coin_detail_state.dart';

@injectable
class CoinDetailBloc
    extends Bloc<CoinDetailEvent, CoinDetailState> {
  final GetCoinDetailUseCase getCoinDetailUseCase;

  CoinDetailBloc(
    this.getCoinDetailUseCase,
  ) : super(
          const CoinDetailState(),
        ) {
    on<LoadCoinDetail>(_onLoadCoinDetail);
  }

  Future<void> _onLoadCoinDetail(
    LoadCoinDetail event,
    Emitter<CoinDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CoinDetailStatus.loading,
      ),
    );

    try {
      final coin = await getCoinDetailUseCase(
        event.coinId,
      );

      emit(
        state.copyWith(
          status: CoinDetailStatus.success,
          coin: coin,
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
          status: CoinDetailStatus.failure,
          errorMessage: message,
        ),
      );
    }
  }
}