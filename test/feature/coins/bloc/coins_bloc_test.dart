import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:crypto_insights/feature/coins/bloc/coins_bloc.dart';
import 'package:crypto_insights/feature/coins/bloc/coins_event.dart';
import 'package:crypto_insights/feature/coins/bloc/coins_state.dart';
import 'package:crypto_insights/feature/coins/domain/usecases/get_coins_use_case.dart';
import 'package:crypto_insights/feature/coins/domain/entities/coin_entity.dart';
import 'package:crypto_insights/core/error/failure.dart';

class MockGetCoinsUseCase extends Mock implements GetCoinsUseCase {}

void main() {
  late MockGetCoinsUseCase mockGetCoinsUseCase;

  setUp(() {
    mockGetCoinsUseCase = MockGetCoinsUseCase();
  });

  blocTest<CoinsBloc, CoinsState>(
    'emits loading then success when coins load successfully',
    build: () {
      when(() => mockGetCoinsUseCase()).thenAnswer((_) async => []);

      return CoinsBloc(mockGetCoinsUseCase);
    },
    act: (bloc) => bloc.add(LoadCoins()),
    expect: () => [
      isA<CoinsState>().having(
        (state) => state.status,
        'status',
        CoinsStatus.loading,
      ),
      isA<CoinsState>().having(
        (state) => state.status,
        'status',
        CoinsStatus.success,
      ),
    ],
  );

  blocTest<CoinsBloc, CoinsState>(
    'emits loading then failure when network request fails',
    build: () {
      when(
        () => mockGetCoinsUseCase(),
      ).thenThrow(const NetworkFailure('no internet'));

      return CoinsBloc(mockGetCoinsUseCase);
    },
    act: (bloc) => bloc.add(LoadCoins()),
    expect: () => [
      isA<CoinsState>().having(
        (state) => state.status,
        'status',
        CoinsStatus.loading,
      ),
      isA<CoinsState>()
          .having((state) => state.status, 'status', CoinsStatus.failure)
          .having((state) => state.error, 'error', isA<NetworkFailure>()),
    ],
  );
  blocTest<CoinsBloc, CoinsState>(
  'emits loading then failure when unknown exception occurs',
  build: () {
    when(
      () => mockGetCoinsUseCase(),
    ).thenThrow(Exception('boom'));

    return CoinsBloc(mockGetCoinsUseCase);
  },
  act: (bloc) => bloc.add(LoadCoins()),
  expect: () => [
    isA<CoinsState>().having(
      (state) => state.status,
      'status',
      CoinsStatus.loading,
    ),
    isA<CoinsState>()
        .having(
          (state) => state.status,
          'status',
          CoinsStatus.failure,
        )
        .having(
          (state) => state.error,
          'error',
          isA<UnknownFailure>(),
        ),
  ],
);

  blocTest<CoinsBloc, CoinsState>(
    'emits loading then failure when server request fails',
    build: () {
      when(
        () => mockGetCoinsUseCase(),
      ).thenThrow(const ServerFailure('server error'));

      return CoinsBloc(mockGetCoinsUseCase);
    },
    act: (bloc) => bloc.add(LoadCoins()),
    expect: () => [
      isA<CoinsState>().having(
        (state) => state.status,
        'status',
        CoinsStatus.loading,
      ),
      isA<CoinsState>()
          .having((state) => state.status, 'status', CoinsStatus.failure)
          .having((state) => state.error, 'error', isA<ServerFailure>()),
    ],
  );
  blocTest<CoinsBloc, CoinsState>(
  'refresh coins reloads data',
  build: () {
    when(
  () => mockGetCoinsUseCase(
    forceRefresh: true,
  ),
).thenAnswer((_) async => []);
    return CoinsBloc(mockGetCoinsUseCase);
  },
  act: (bloc) => bloc.add(RefreshCoins()),
  expect: () => [
    isA<CoinsState>().having(
      (state) => state.status,
      'status',
      CoinsStatus.loading,
    ),
    isA<CoinsState>().having(
      (state) => state.status,
      'status',
      CoinsStatus.success,
    ),
  ],
);

  blocTest<CoinsBloc, CoinsState>(
    'refresh coins emits failure when refresh request fails',
    build: () {
      when(
        () => mockGetCoinsUseCase(forceRefresh: true),
      ).thenThrow(const NetworkFailure('no internet'));

      return CoinsBloc(mockGetCoinsUseCase);
    },
    act: (bloc) => bloc.add(RefreshCoins()),
    expect: () => [
      isA<CoinsState>().having(
        (state) => state.status,
        'status',
        CoinsStatus.loading,
      ),
      isA<CoinsState>()
          .having((state) => state.status, 'status', CoinsStatus.failure)
          .having((state) => state.error, 'error', isA<NetworkFailure>()),
    ],
  );
blocTest<CoinsBloc, CoinsState>(
  'search coins updates query',
  build: () => CoinsBloc(mockGetCoinsUseCase),
  act: (bloc) => bloc.add(
    SearchCoins('btc'),
  ),
  expect: () => [
    isA<CoinsState>().having(
      (state) => state.query,
      'query',
      'btc',
    ),
  ],
);
  final btc = CoinEntity(
    id: 'btc',
    symbol: 'btc',
    name: 'Bitcoin',
    image: '',
    currentPrice: 100000,
    priceChange24h: 5,
    marketCapRank: 1,
  );

  final eth = CoinEntity(
    id: 'eth',
    symbol: 'eth',
    name: 'Ethereum',
    image: '',
    currentPrice: 3000,
    priceChange24h: 10,
    marketCapRank: 2,
  );

blocTest<CoinsBloc, CoinsState>(
  'sorts by market cap',
  build: () => CoinsBloc(mockGetCoinsUseCase),
  seed: () => CoinsState(
    coins: [eth, btc],
  ),
  act: (bloc) => bloc.add(SortCoins('marketCap')),
  expect: () => [
    isA<CoinsState>()
        .having((s) => s.coins.first.id, 'first coin', 'btc')
        .having((s) => s.sortBy, 'sortBy', 'marketCap'),
  ],
);

blocTest<CoinsBloc, CoinsState>(
  'sorts by 24h change descending',
  build: () => CoinsBloc(mockGetCoinsUseCase),
  seed: () => CoinsState(
    coins: [btc, eth],
  ),
  act: (bloc) => bloc.add(SortCoins('change24hDesc')),
  expect: () => [
    isA<CoinsState>()
        .having((s) => s.coins.first.id, 'first coin', 'eth')
        .having((s) => s.sortBy, 'sortBy', 'change24hDesc'),
  ],
);

blocTest<CoinsBloc, CoinsState>(
  'sorts by 24h change ascending',
  build: () => CoinsBloc(mockGetCoinsUseCase),
  seed: () => CoinsState(
    coins: [eth, btc],
  ),
  act: (bloc) => bloc.add(SortCoins('change24hAsc')),
  expect: () => [
    isA<CoinsState>()
        .having((s) => s.coins.first.id, 'first coin', 'btc')
        .having((s) => s.sortBy, 'sortBy', 'change24hAsc'),
  ],
);

blocTest<CoinsBloc, CoinsState>(
  'load more increases visible count',
  build: () => CoinsBloc(mockGetCoinsUseCase),
  seed: () => CoinsState(
    coins: List.generate(40, (_) => btc),
    visibleCount: 20,
  ),
  act: (bloc) => bloc.add(LoadMoreCoins()),
  expect: () => [
    isA<CoinsState>().having(
      (s) => s.visibleCount,
      'visibleCount',
      40,
    ),
  ],
);

blocTest<CoinsBloc, CoinsState>(
  'load more does nothing when all items are visible',
  build: () => CoinsBloc(mockGetCoinsUseCase),
  seed: () => CoinsState(
    coins: List.generate(20, (_) => btc),
    visibleCount: 20,
  ),
  act: (bloc) => bloc.add(LoadMoreCoins()),
  expect: () => <CoinsState>[],
);
}
