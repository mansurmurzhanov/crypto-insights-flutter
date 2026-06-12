import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:crypto_insights/core/error/failure.dart';
import 'package:crypto_insights/feature/coin_detail/domain/usecases/get_coin_chart_use_case.dart';
import 'package:crypto_insights/feature/coin_detail/domain/usecases/get_coin_detail_use_case.dart';
import 'package:crypto_insights/feature/coin_detail/presentation/bloc/coin_detail_bloc.dart';
import 'package:crypto_insights/feature/coin_detail/presentation/bloc/coin_detail_event.dart';
import 'package:crypto_insights/feature/coin_detail/presentation/bloc/coin_detail_state.dart';

class MockGetCoinDetailUseCase extends Mock
    implements GetCoinDetailUseCase {}

class MockGetCoinChartUseCase extends Mock
    implements GetCoinChartUseCase {}

void main() {
  late MockGetCoinDetailUseCase getCoinDetailUseCase;
  late MockGetCoinChartUseCase getCoinChartUseCase;

  setUp(() {
    getCoinDetailUseCase = MockGetCoinDetailUseCase();
    getCoinChartUseCase = MockGetCoinChartUseCase();
  });

  blocTest<CoinDetailBloc, CoinDetailState>(
    'emits loading then success when coin detail loads successfully',
    build: () {
      when(
        () => getCoinDetailUseCase(any()),
      ).thenAnswer((_) async => throw UnimplementedError());

      return CoinDetailBloc(
        getCoinDetailUseCase,
        getCoinChartUseCase,
      );
    },
    act: (bloc) => bloc.add(
      LoadCoinDetail('bitcoin'),
    ),
    expect: () => [
      isA<CoinDetailState>().having(
        (state) => state.status,
        'status',
        CoinDetailStatus.loading,
      ),
      isA<CoinDetailState>().having(
        (state) => state.status,
        'status',
        CoinDetailStatus.failure,
      ),
    ],
  );

  blocTest<CoinDetailBloc, CoinDetailState>(
    'emits failure when detail request fails',
    build: () {
      when(
        () => getCoinDetailUseCase(any()),
      ).thenThrow(
        const NetworkFailure('no internet'),
      );

      return CoinDetailBloc(
        getCoinDetailUseCase,
        getCoinChartUseCase,
      );
    },
    act: (bloc) => bloc.add(
      LoadCoinDetail('bitcoin'),
    ),
    expect: () => [
      isA<CoinDetailState>().having(
        (state) => state.status,
        'status',
        CoinDetailStatus.loading,
      ),
      isA<CoinDetailState>().having(
        (state) => state.status,
        'status',
        CoinDetailStatus.failure,
      ),
    ],
  );
}