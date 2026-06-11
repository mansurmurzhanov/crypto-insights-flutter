import 'package:flutter_bloc/flutter_bloc.dart';

import '../../coin_detail/domain/entities/coin_detail_entity.dart';
import '../../coin_detail/domain/usecases/get_coin_detail_use_case.dart';

class FavoriteCoinDetailsCubit extends Cubit<Object?> {
  FavoriteCoinDetailsCubit(this._getCoinDetailUseCase) : super(null);

  final GetCoinDetailUseCase _getCoinDetailUseCase;

  Future<CoinDetailEntity> getCoinDetail(String coinId) {
    return _getCoinDetailUseCase(coinId);
  }
}
