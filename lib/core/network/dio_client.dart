import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'api_constants.dart';

@lazySingleton
class DioClient {
  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );
  }

  late final Dio dio;
}