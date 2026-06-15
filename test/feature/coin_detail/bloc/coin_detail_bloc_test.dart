import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:crypto_insights/core/error/failure.dart';
import 'package:crypto_insights/feature/coin_detail/domain/entities/coin_chart_point_entity.dart';
import 'package:crypto_insights/feature/coin_detail/domain/entities/coin_detail_entity.dart';
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

  final coin = CoinDetailEntity(
    id: 'btc',
    name: 'Bitcoin',
    symbol: 'btc',
    image: '',
    currentPrice: 100000,
    marketCap: 1000000,
    volume: 500000,
    marketCapRank: 1,
    ath: 110000,
    atl: 1,
  );

  final points = [
    CoinChartPointEntity(
      time: DateTime(2024, 1, 1),
      price: 100000,
    ),
  ];

  setUp(() {
    getCoinDetailUseCase = MockGetCoinDetailUseCase();
    getCoinChartUseCase = MockGetCoinChartUseCase();
  });

  blocTest<CoinDetailBloc, CoinDetailState>(
    'detail success',
    build: () {
      when(
        () => getCoinDetailUseCase(any()),
      ).thenAnswer((_) async => coin);

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
        (s) => s.status,
        'status',
        CoinDetailStatus.loading,
      ),
      isA<CoinDetailState>()
          .having(
            (s) => s.status,
            'status',
            CoinDetailStatus.success,
          )
          .having(
            (s) => s.coin?.id,
            'coin',
            'btc',
          ),
    ],
  );

  blocTest<CoinDetailBloc, CoinDetailState>(
    'detail network failure',
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
        (s) => s.status,
        'status',
        CoinDetailStatus.loading,
      ),
      isA<CoinDetailState>().having(
        (s) => s.status,
        'status',
        CoinDetailStatus.failure,
      ),
    ],
  );

  blocTest<CoinDetailBloc, CoinDetailState>(
    'detail unknown failure',
    build: () {
      when(
        () => getCoinDetailUseCase(any()),
      ).thenThrow(
        Exception('boom'),
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
        (s) => s.status,
        'status',
        CoinDetailStatus.loading,
      ),
      isA<CoinDetailState>()
          .having(
            (s) => s.status,
            'status',
            CoinDetailStatus.failure,
          )
          .having(
            (s) => s.failure,
            'failure',
            isA<UnknownFailure>(),
          ),
    ],
  );

  blocTest<CoinDetailBloc, CoinDetailState>(
    'chart success',
    build: () {
      when(
        () => getCoinChartUseCase(any(), any()),
      ).thenAnswer((_) async => points);

      return CoinDetailBloc(
        getCoinDetailUseCase,
        getCoinChartUseCase,
      );
    },
    act: (bloc) => bloc.add(
      LoadCoinChart(
        coinId: 'btc',
        days: 1,
      ),
    ),
    expect: () => [
      isA<CoinDetailState>().having(
        (s) => s.chartStatus,
        'chartStatus',
        CoinChartStatus.loading,
      ),
      isA<CoinDetailState>()
          .having(
            (s) => s.chartStatus,
            'chartStatus',
            CoinChartStatus.success,
          )
          .having(
            (s) => s.points.length,
            'points',
            1,
          ),
    ],
  );

  blocTest<CoinDetailBloc, CoinDetailState>(
    'chart failure',
    build: () {
      when(
        () => getCoinChartUseCase(any(), any()),
      ).thenThrow(
        Exception('chart error'),
      );

      return CoinDetailBloc(
        getCoinDetailUseCase,
        getCoinChartUseCase,
      );
    },
    act: (bloc) => bloc.add(
      LoadCoinChart(
        coinId: 'btc',
        days: 1,
      ),
    ),
    expect: () => [
      isA<CoinDetailState>().having(
        (s) => s.chartStatus,
        'chartStatus',
        CoinChartStatus.loading,
      ),
      isA<CoinDetailState>().having(
        (s) => s.chartStatus,
        'chartStatus',
        CoinChartStatus.failure,
      ),
    ],
  );

  blocTest<CoinDetailBloc, CoinDetailState>(
    'change chart period to 7 days',
    build: () {
      when(
        () => getCoinChartUseCase(any(), any()),
      ).thenAnswer((_) async => points);

      return CoinDetailBloc(
        getCoinDetailUseCase,
        getCoinChartUseCase,
      );
    },
    act: (bloc) => bloc.add(
      ChangeChartPeriod(
        coinId: 'btc',
        days: 7,
      ),
    ),
    expect: () => [
      isA<CoinDetailState>().having(
        (s) => s.selectedDays,
        'selectedDays',
        7,
      ),
      isA<CoinDetailState>().having(
        (s) => s.chartStatus,
        'chartStatus',
        CoinChartStatus.loading,
      ),
      isA<CoinDetailState>().having(
        (s) => s.chartStatus,
        'chartStatus',
        CoinChartStatus.success,
      ),
    ],
  );

  blocTest<CoinDetailBloc, CoinDetailState>(
    'change chart period to 30 days',
    build: () {
      when(
        () => getCoinChartUseCase(any(), any()),
      ).thenAnswer((_) async => points);

      return CoinDetailBloc(
        getCoinDetailUseCase,
        getCoinChartUseCase,
      );
    },
    act: (bloc) => bloc.add(
      ChangeChartPeriod(
        coinId: 'btc',
        days: 30,
      ),
    ),
    expect: () => [
      isA<CoinDetailState>().having(
        (s) => s.selectedDays,
        'selectedDays',
        30,
      ),
      isA<CoinDetailState>().having(
        (s) => s.chartStatus,
        'chartStatus',
        CoinChartStatus.loading,
      ),
      isA<CoinDetailState>().having(
        (s) => s.chartStatus,
        'chartStatus',
        CoinChartStatus.success,
      ),
    ],
  );

  blocTest<CoinDetailBloc, CoinDetailState>(
    'change chart period to 24h (1 day)',
    build: () {
      when(
        () => getCoinChartUseCase(any(), any()),
      ).thenAnswer((_) async => points);

      return CoinDetailBloc(
        getCoinDetailUseCase,
        getCoinChartUseCase,
      );
    },
    act: (bloc) => bloc.add(
      ChangeChartPeriod(
        coinId: 'btc',
        days: 1,
      ),
    ),
    expect: () => [
      isA<CoinDetailState>().having(
        (s) => s.selectedDays,
        'selectedDays',
        1,
      ),
      isA<CoinDetailState>().having(
        (s) => s.chartStatus,
        'chartStatus',
        CoinChartStatus.loading,
      ),
      isA<CoinDetailState>().having(
        (s) => s.chartStatus,
        'chartStatus',
        CoinChartStatus.success,
      ),
    ],
  );

  blocTest<CoinDetailBloc, CoinDetailState>(
    'retry after failure succeeds',
    build: () {
      var callCount = 0;

      when(
        () => getCoinDetailUseCase(any()),
      ).thenAnswer((_) async {
        callCount++;

        if (callCount == 1) {
          throw const NetworkFailure('no internet');
        }

        return coin;
      });

      return CoinDetailBloc(
        getCoinDetailUseCase,
        getCoinChartUseCase,
      );
    },
    act: (bloc) async {
      bloc.add(
        LoadCoinDetail('bitcoin'),
      );

      await Future<void>.delayed(
        const Duration(milliseconds: 10),
      );

      bloc.add(
        LoadCoinDetail('bitcoin'),
      );
    },
    expect: () => [
      isA<CoinDetailState>().having(
        (s) => s.status,
        'status',
        CoinDetailStatus.loading,
      ),
      isA<CoinDetailState>().having(
        (s) => s.status,
        'status',
        CoinDetailStatus.failure,
      ),
      isA<CoinDetailState>().having(
        (s) => s.status,
        'status',
        CoinDetailStatus.loading,
      ),
      isA<CoinDetailState>().having(
        (s) => s.status,
        'status',
        CoinDetailStatus.success,
      ),
    ],
  );
}