import 'package:injectable/injectable.dart';
import '../favorites_repository.dart';

@injectable
class AddFavoriteUseCase {
  final FavoritesRepository repository;

  AddFavoriteUseCase(this.repository);

  Future<void> call(String coinId) {
    return repository.addFavorite(coinId);
  }
}