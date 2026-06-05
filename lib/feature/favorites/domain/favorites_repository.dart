abstract class FavoritesRepository {
  Future<List<String>> getFavorites();

  Future<void> addFavorite(String coinId);

  Future<void> removeFavorite(String coinId);
}