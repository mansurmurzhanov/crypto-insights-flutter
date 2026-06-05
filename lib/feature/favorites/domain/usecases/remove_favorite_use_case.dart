import '../favorites_repository.dart';

class RemoveFavoriteUseCase {
  final FavoritesRepository repository;

  RemoveFavoriteUseCase(this.repository);

  Future<void> call(String coinId) {
    return repository.removeFavorite(coinId);
  }
}