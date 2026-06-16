import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:crypto_insights/feature/coins/domain/entities/coin_entity.dart';
import 'package:crypto_insights/feature/coins/domain/repositories/coins_repository.dart';
import 'package:crypto_insights/feature/coins/domain/usecases/get_coins_use_case.dart';

class MockCoinsRepository extends Mock
    implements CoinsRepository {}

void main() {
  late MockCoinsRepository repository;
  late GetCoinsUseCase useCase;

  const coins = [
    CoinEntity(
      id: 'btc',
      symbol: 'btc',
      name: 'Bitcoin',
      image: '',
      currentPrice: 100000,
      priceChange24h: 5.2,
      marketCapRank: 1,
    ),
  ];

  setUp(() {
    repository = MockCoinsRepository();
    useCase = GetCoinsUseCase(repository);
  });

  test(
    'calls repository getCoins with forceRefresh false',
    () async {
      when(
        () => repository.getCoins(
          forceRefresh: false,
        ),
      ).thenAnswer((_) async => coins);

      final result = await useCase();

      expect(result, coins);

      verify(
        () => repository.getCoins(
          forceRefresh: false,
        ),
      ).called(1);
    },
  );

  test(
    'calls repository getCoins with forceRefresh true',
    () async {
      when(
        () => repository.getCoins(
          forceRefresh: true,
        ),
      ).thenAnswer((_) async => coins);

      final result = await useCase(
        forceRefresh: true,
      );

      expect(result, coins);

      verify(
        () => repository.getCoins(
          forceRefresh: true,
        ),
      ).called(1);
    },
  );
}