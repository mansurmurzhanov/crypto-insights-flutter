import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:crypto_insights/feature/favorites/domain/favorites_repository.dart';
import 'package:crypto_insights/feature/favorites/domain/usecases/add_favorite_use_case.dart';

class MockFavoritesRepository extends Mock
    implements FavoritesRepository {}

void main() {
  late MockFavoritesRepository repository;
  late AddFavoriteUseCase useCase;

  setUp(() {
    repository = MockFavoritesRepository();
    useCase = AddFavoriteUseCase(repository);
  });

  test(
    'calls repository addFavorite',
    () async {
      when(
        () => repository.addFavorite('btc'),
      ).thenAnswer((_) async {});

      await useCase('btc');

      verify(
        () => repository.addFavorite('btc'),
      ).called(1);
    },
  );
}