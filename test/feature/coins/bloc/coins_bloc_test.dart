import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:crypto_insights/feature/coins/bloc/coins_bloc.dart';
import 'package:crypto_insights/feature/coins/bloc/coins_event.dart';
import 'package:crypto_insights/feature/coins/bloc/coins_state.dart';
import 'package:crypto_insights/feature/coins/domain/usecases/get_coins_use_case.dart';
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
}
