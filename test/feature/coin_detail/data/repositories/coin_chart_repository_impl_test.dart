import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:crypto_insights/feature/coin_detail/data/repositories/coin_chart_repository_impl.dart';
import 'package:crypto_insights/feature/coin_detail/data/datasources/coin_chart_remote_data_source.dart';
import 'package:crypto_insights/feature/coin_detail/data/models/coin_chart_point_model.dart';

class MockCoinChartRemoteDataSource extends Mock
    implements CoinChartRemoteDataSource {}

void main() {
  late MockCoinChartRemoteDataSource remote;
  late CoinChartRepositoryImpl repository;

  setUp(() {
    remote = MockCoinChartRemoteDataSource();
    repository = CoinChartRepositoryImpl(remote);
  });

  test('returns chart points from datasource', () async {
    final points = [
      CoinChartPointModel(
        time: DateTime.now(),
        price: 100000,
      ),
    ];

    when(
      () => remote.getChart('btc', 7),
    ).thenAnswer((_) async => points);

    final result = await repository.getChart(
      'btc',
      7,
    );

    expect(result, points);

    verify(
      () => remote.getChart(
        'btc',
        7,
      ),
    ).called(1);
  });
}