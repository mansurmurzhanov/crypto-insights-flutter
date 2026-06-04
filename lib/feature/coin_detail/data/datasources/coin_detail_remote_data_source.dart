import 'package:injectable/injectable.dart';

import '../../../../core/network/dio_client.dart';

import '../models/coin_detail_model.dart';

abstract class CoinDetailRemoteDataSource {
  Future<CoinDetailModel> getCoinDetail(
    String coinId,
  );
}

@Injectable(as: CoinDetailRemoteDataSource)
class CoinDetailRemoteDataSourceImpl
    implements CoinDetailRemoteDataSource {
  final DioClient dioClient;

  CoinDetailRemoteDataSourceImpl(
    this.dioClient,
  );

  @override
  Future<CoinDetailModel> getCoinDetail(
    String coinId,
  ) async {
    final response = await dioClient.dio.get(
      '/coins/$coinId',
    );

    return CoinDetailModel.fromJson(
      response.data,
    );
  }
}