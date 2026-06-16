import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:crypto_insights/feature/coin_detail/domain/entities/coin_detail_entity.dart';
import 'package:crypto_insights/feature/coin_detail/domain/repositories/coin_detail_repository.dart';
import 'package:crypto_insights/feature/coin_detail/domain/usecases/get_coin_detail_use_case.dart';

class MockCoinDetailRepository extends Mock
    implements CoinDetailRepository {}

void main() {
  late MockCoinDetailRepository repository;
  late GetCoinDetailUseCase useCase;

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

  setUp(() {
    repository = MockCoinDetailRepository();
    useCase = GetCoinDetailUseCase(repository);
  });

  test(
    'calls repository getCoinDetail',
    () async {
      when(
        () => repository.getCoinDetail('btc'),
      ).thenAnswer((_) async => coin);

      final result = await useCase('btc');

      expect(result, coin);

      verify(
        () => repository.getCoinDetail('btc'),
      ).called(1);
    },
  );
}