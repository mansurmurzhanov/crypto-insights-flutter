import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:crypto_insights/feature/coins/data/datasource/coins_remote_data_source.dart';
import 'package:crypto_insights/feature/coins/data/models/coin_model.dart';
import 'package:crypto_insights/feature/coins/data/repositories/coins_repository_impl.dart';

class MockCoinsRemoteDataSource extends Mock
    implements CoinsRemoteDataSource {}

void main() {
  late MockCoinsRemoteDataSource remote;
  late CoinsRepositoryImpl repository;

  setUp(() {
    remote = MockCoinsRemoteDataSource();
    repository = CoinsRepositoryImpl(remote);
  });

  test(
    'returns coins from remote datasource',
    () async {
      const coins = [
        CoinModel(
          id: 'btc',
          symbol: 'btc',
          name: 'Bitcoin',
          image: '',
          currentPrice: 100000,
          priceChange24h: 5,
          marketCapRank: 1,
        ),
      ];

      when(
        () => remote.getCoins(
          forceRefresh: true,
        ),
      ).thenAnswer(
        (_) async => coins,
      );

      final result = await repository.getCoins(
        forceRefresh: true,
      );

      expect(
        result,
        coins,
      );

      verify(
        () => remote.getCoins(
          forceRefresh: true,
        ),
      ).called(1);
    },
  );
}