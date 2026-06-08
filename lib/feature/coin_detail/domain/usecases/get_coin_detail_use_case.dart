import 'package:injectable/injectable.dart';
import '../entities/coin_detail_entity.dart';
import '../repositories/coin_detail_repository.dart';

@injectable
class GetCoinDetailUseCase {
  final CoinDetailRepository repository;

  GetCoinDetailUseCase(this.repository);

  Future<CoinDetailEntity> call(
    String coinId,
  ) {
    return repository.getCoinDetail(
      coinId,
    );
  }
}