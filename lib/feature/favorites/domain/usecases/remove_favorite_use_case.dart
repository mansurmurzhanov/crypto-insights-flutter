import 'package:injectable/injectable.dart';
import '../favorites_repository.dart';

@injectable
class RemoveFavoriteUseCase {
  final FavoritesRepository repository;

  RemoveFavoriteUseCase(this.repository);

  Future<void> call(String coinId) {
    return repository.removeFavorite(coinId);
  }
}