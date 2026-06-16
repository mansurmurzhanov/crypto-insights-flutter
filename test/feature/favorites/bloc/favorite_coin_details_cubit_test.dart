import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:crypto_insights/feature/coin_detail/domain/entities/coin_detail_entity.dart';
import 'package:crypto_insights/feature/coin_detail/domain/usecases/get_coin_detail_use_case.dart';
import 'package:crypto_insights/feature/favorites/bloc/favorite_coin_details_cubit.dart';

class MockGetCoinDetailUseCase extends Mock
    implements GetCoinDetailUseCase {}

void main() {
  late MockGetCoinDetailUseCase getCoinDetailUseCase;
  late FavoriteCoinDetailsCubit cubit;

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
    getCoinDetailUseCase = MockGetCoinDetailUseCase();

    cubit = FavoriteCoinDetailsCubit(
      getCoinDetailUseCase,
    );
  });

  test(
    'getCoinDetail returns coin from use case',
    () async {
      when(
        () => getCoinDetailUseCase('btc'),
      ).thenAnswer(
        (_) async => coin,
      );

      final result = await cubit.getCoinDetail(
        'btc',
      );

      expect(
        result,
        equals(coin),
      );

      verify(
        () => getCoinDetailUseCase('btc'),
      ).called(1);
    },
  );
}