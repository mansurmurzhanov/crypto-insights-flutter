import '../favorites_repository.dart';

class GetFavoritesUseCase {
  final FavoritesRepository repository;

  GetFavoritesUseCase(this.repository);

  Future<List<String>> call() {
    return repository.getFavorites();
  }
}