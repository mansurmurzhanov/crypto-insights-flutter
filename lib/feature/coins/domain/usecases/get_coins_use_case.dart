import 'package:injectable/injectable.dart';

import '../entities/coin_entity.dart';
import '../repositories/coins_repository.dart';

@injectable
class GetCoinsUseCase {
  final CoinsRepository repository;

  GetCoinsUseCase(this.repository);

  Future<List<CoinEntity>> call() {
    return repository.getCoins();
  }
}