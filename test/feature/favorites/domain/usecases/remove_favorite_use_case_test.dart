import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:crypto_insights/feature/favorites/domain/favorites_repository.dart';
import 'package:crypto_insights/feature/favorites/domain/usecases/remove_favorite_use_case.dart';

class MockFavoritesRepository extends Mock
    implements FavoritesRepository {}

void main() {
  late MockFavoritesRepository repository;
  late RemoveFavoriteUseCase useCase;

  setUp(() {
    repository = MockFavoritesRepository();
    useCase = RemoveFavoriteUseCase(repository);
  });

  test(
    'calls repository removeFavorite',
    () async {
      when(
        () => repository.removeFavorite('btc'),
      ).thenAnswer((_) async {});

      await useCase('btc');

      verify(
        () => repository.removeFavorite('btc'),
      ).called(1);
    },
  );
}