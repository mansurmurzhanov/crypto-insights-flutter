import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:crypto_insights/feature/favorites/domain/favorites_repository.dart';
import 'package:crypto_insights/feature/favorites/domain/usecases/get_favorites_use_case.dart';

class MockFavoritesRepository extends Mock
    implements FavoritesRepository {}

void main() {
  late MockFavoritesRepository repository;
  late GetFavoritesUseCase useCase;

  setUp(() {
    repository = MockFavoritesRepository();
    useCase = GetFavoritesUseCase(repository);
  });

  test(
    'calls repository getFavorites',
    () async {
      when(
        () => repository.getFavorites(),
      ).thenAnswer(
        (_) async => ['btc'],
      );

      final result = await useCase();

      expect(
        result,
        ['btc'],
      );

      verify(
        () => repository.getFavorites(),
      ).called(1);
    },
  );
}