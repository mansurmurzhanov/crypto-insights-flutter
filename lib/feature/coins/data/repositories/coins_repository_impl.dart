import 'package:injectable/injectable.dart';

import '../../domain/entities/coin_entity.dart';
import '../../domain/repositories/coins_repository.dart';
import '../datasource/coins_remote_data_source.dart';

@LazySingleton(as: CoinsRepository)
class CoinsRepositoryImpl implements CoinsRepository {
  final CoinsRemoteDataSource remote;

  CoinsRepositoryImpl(this.remote);

  @override
  Future<List<CoinEntity>> getCoins() async {
    final result = await remote.getCoins();
    return result;
  }
}