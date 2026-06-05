sealed class FavoritesEvent {}

final class LoadFavorites extends FavoritesEvent {}

final class AddFavorite extends FavoritesEvent {
  final String coinId;

  AddFavorite(this.coinId);
}

final class RemoveFavorite extends FavoritesEvent {
  final String coinId;

  RemoveFavorite(this.coinId);
}