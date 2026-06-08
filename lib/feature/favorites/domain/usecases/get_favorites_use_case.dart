import 'package:injectable/injectable.dart';
import '../favorites_repository.dart';

@injectable
class GetFavoritesUseCase {
  final FavoritesRepository repository;

  GetFavoritesUseCase(this.repository);

  Future<List<String>> call() {
    return repository.getFavorites();
  }
}