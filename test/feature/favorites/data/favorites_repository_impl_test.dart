import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:crypto_insights/feature/favorites/data/favorites_repository_impl.dart';

void main() {
  late FavoritesRepositoryImpl repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = FavoritesRepositoryImpl();
  });

  test('returns empty favorites initially', () async {
    final result = await repository.getFavorites();

    expect(result, isEmpty);
  });

  test('adds favorite', () async {
    await repository.addFavorite('btc');

    final result = await repository.getFavorites();

    expect(result, ['btc']);
  });

  test('does not duplicate favorite', () async {
    await repository.addFavorite('btc');
    await repository.addFavorite('btc');

    final result = await repository.getFavorites();

    expect(result.length, 1);
  });

  test('removes favorite', () async {
    await repository.addFavorite('btc');

    await repository.removeFavorite('btc');

    final result = await repository.getFavorites();

    expect(result, isEmpty);
  });
}