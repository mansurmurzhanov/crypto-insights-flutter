import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../domain/usecases/get_coin_chart_use_case.dart';
import '../../domain/usecases/get_coin_detail_use_case.dart';
import 'coin_detail_event.dart';
import 'coin_detail_state.dart';

@injectable
class CoinDetailBloc extends Bloc<CoinDetailEvent, CoinDetailState> {
  final GetCoinDetailUseCase getCoinDetailUseCase;
  final GetCoinChartUseCase getCoinChartUseCase;

  CoinDetailBloc(
    this.getCoinDetailUseCase,
    this.getCoinChartUseCase,
  ) : super(const CoinDetailState()) {
    on<LoadCoinDetail>(_onLoadCoinDetail);
    on<LoadCoinChart>(_onLoadCoinChart);
    on<ChangeChartPeriod>(_onChangeChartPeriod);
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
      emit(
        state.copyWith(
          status: CoinDetailStatus.failure,
          failure: e is Failure
              ? e
              : const UnknownFailure(
                  'Unexpected error',
                ),
        ),
      );
    }
  }

  Future<void> _onLoadCoinChart(
    LoadCoinChart event,
    Emitter<CoinDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        chartStatus: CoinChartStatus.loading,
      ),
    );

    try {
      final points = await getCoinChartUseCase(
        event.coinId,
        event.days,
      );

      emit(
        state.copyWith(
          chartStatus: CoinChartStatus.success,
          points: points,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          chartStatus: CoinChartStatus.failure,
          chartErrorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onChangeChartPeriod(
    ChangeChartPeriod event,
    Emitter<CoinDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedDays: event.days,
      ),
    );

    add(
      LoadCoinChart(
        coinId: event.coinId,
        days: event.days,
      ),
    );
  }
}