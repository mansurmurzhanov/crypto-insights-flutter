import 'package:dio/dio.dart';

import 'failure.dart';

Failure mapDioException(DioException exception) {
  switch (exception.type) {
    case DioExceptionType.connectionError:
      return const NetworkFailure(
        'No internet connection',
      );

    case DioExceptionType.connectionTimeout:
      return const NetworkFailure(
        'Connection timeout',
      );

    case DioExceptionType.receiveTimeout:
      return const NetworkFailure(
        'Receive timeout',
      );

    case DioExceptionType.badResponse:
      return ServerFailure(
        exception.response?.statusMessage ??
            'Server error',
      );

    default:
      return const UnknownFailure(
        'Unexpected error',
      );
  }
}