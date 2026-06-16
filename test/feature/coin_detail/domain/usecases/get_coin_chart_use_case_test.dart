import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:crypto_insights/feature/coin_detail/domain/entities/coin_chart_point_entity.dart';
import 'package:crypto_insights/feature/coin_detail/domain/repositories/coin_chart_repository.dart';
import 'package:crypto_insights/feature/coin_detail/domain/usecases/get_coin_chart_use_case.dart';

class MockCoinChartRepository extends Mock
    implements CoinChartRepository {}

void main() {
  late MockCoinChartRepository repository;
  late GetCoinChartUseCase useCase;

  final points = [
    CoinChartPointEntity(
      time: DateTime(2024, 1, 1),
      price: 100000,
    ),
  ];

  setUp(() {
    repository = MockCoinChartRepository();
    useCase = GetCoinChartUseCase(repository);
  });

  test(
    'calls repository getChart',
    () async {
      when(
        () => repository.getChart('btc', 7),
      ).thenAnswer((_) async => points);

      final result = await useCase('btc', 7);

      expect(result, points);

      verify(
        () => repository.getChart('btc', 7),
      ).called(1);
    },
  );
}