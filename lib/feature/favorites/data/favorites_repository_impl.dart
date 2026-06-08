import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:crypto_insights/feature/favorites/domain/favorites_repository.dart';


@LazySingleton(as: FavoritesRepository)
class FavoritesRepositoryImpl implements FavoritesRepository {
  static const _key = 'favorites';

  @override
  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(_key) ?? [];
  }

  @override
  Future<void> addFavorite(String coinId) async {
    final prefs = await SharedPreferences.getInstance();

    final favorites = prefs.getStringList(_key) ?? [];

    if (!favorites.contains(coinId)) {
      favorites.add(coinId);
      await prefs.setStringList(_key, favorites);
    }
  }

  @override
  Future<void> removeFavorite(String coinId) async {
    final prefs = await SharedPreferences.getInstance();

    final favorites = prefs.getStringList(_key) ?? [];

    favorites.remove(coinId);

    await prefs.setStringList(_key, favorites);
  }
}