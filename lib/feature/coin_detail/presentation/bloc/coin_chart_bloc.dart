import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_coin_chart_use_case.dart';
import 'coin_chart_event.dart';
import 'coin_chart_state.dart';

@injectable
class CoinChartBloc
    extends Bloc<CoinChartEvent, CoinChartState> {
  final GetCoinChartUseCase getCoinChartUseCase;

  CoinChartBloc(
    this.getCoinChartUseCase,
  ) : super(
          const CoinChartState(),
        ) {
    on<LoadCoinChart>(_onLoadCoinChart);
    on<ChangeChartPeriod>(_onChangeChartPeriod);
  }

  Future<void> _onLoadCoinChart(
    LoadCoinChart event,
    Emitter<CoinChartState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CoinChartStatus.loading,
      ),
    );

    try {
      final points = await getCoinChartUseCase(
        event.coinId,
        event.days,
      );

      emit(
        state.copyWith(
          status: CoinChartStatus.success,
          points: points,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CoinChartStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
  Future<void> _onChangeChartPeriod(
    ChangeChartPeriod event,
    Emitter<CoinChartState> emit,
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