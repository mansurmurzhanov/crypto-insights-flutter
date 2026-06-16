import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:crypto_insights/feature/coin_detail/data/repositories/coin_detail_repository_impl.dart';
import 'package:crypto_insights/feature/coin_detail/data/datasources/coin_detail_remote_data_source.dart';
import 'package:crypto_insights/feature/coin_detail/data/models/coin_detail_model.dart';

class MockCoinDetailRemoteDataSource extends Mock
    implements CoinDetailRemoteDataSource {}

void main() {
  late MockCoinDetailRemoteDataSource remote;
  late CoinDetailRepositoryImpl repository;

  setUp(() {
    remote = MockCoinDetailRemoteDataSource();
    repository = CoinDetailRepositoryImpl(remote);
  });

  test('returns coin detail from datasource', () async {
    final coin = CoinDetailModel(
      id: 'btc',
      name: 'Bitcoin',
      symbol: 'btc',
      image: '',
      currentPrice: 100000,
      marketCap: 1,
      volume: 1,
      marketCapRank: 1,
      ath: 1,
      atl: 1,
    );

    when(
      () => remote.getCoinDetail('btc'),
    ).thenAnswer((_) async => coin);

    final result = await repository.getCoinDetail('btc');

    expect(result, coin);

    verify(
      () => remote.getCoinDetail('btc'),
    ).called(1);
  });
}