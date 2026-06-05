import '../favorites_repository.dart';

class AddFavoriteUseCase {
  final FavoritesRepository repository;

  AddFavoriteUseCase(this.repository);

  Future<void> call(String coinId) {
    return repository.addFavorite(coinId);
  }
}