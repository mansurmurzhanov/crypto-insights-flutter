import 'package:injectable/injectable.dart';

import '../../domain/entities/coin_detail_entity.dart';
import '../../domain/repositories/coin_detail_repository.dart';
import '../datasources/coin_detail_remote_data_source.dart';

@LazySingleton(as: CoinDetailRepository)
class CoinDetailRepositoryImpl
    implements CoinDetailRepository {
  final CoinDetailRemoteDataSource remoteDataSource;

  CoinDetailRepositoryImpl(
    this.remoteDataSource,
  );

  @override
  Future<CoinDetailEntity> getCoinDetail(
    String coinId,
  ) {
    return remoteDataSource.getCoinDetail(
      coinId,
    );
  }
}