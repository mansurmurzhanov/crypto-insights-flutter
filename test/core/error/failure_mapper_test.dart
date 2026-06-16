import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:crypto_insights/core/error/failure.dart';
import 'package:crypto_insights/core/error/failure_mapper.dart';

void main() {
  test(
    'maps connectionError to NetworkFailure',
    () {
      final result = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionError,
        ),
      );

      expect(
        result,
        isA<NetworkFailure>(),
      );
    },
  );

  test(
    'maps connectionTimeout to NetworkFailure',
    () {
      final result = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      expect(
        result,
        isA<NetworkFailure>(),
      );
    },
  );

  test(
    'maps receiveTimeout to NetworkFailure',
    () {
      final result = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.receiveTimeout,
        ),
      );

      expect(
        result,
        isA<NetworkFailure>(),
      );
    },
  );

  test(
    'maps badResponse to ServerFailure',
    () {
      final result = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusMessage: 'Server error',
          ),
        ),
      );

      expect(
        result,
        isA<ServerFailure>(),
      );
    },
  );

  test(
    'maps unknown error to UnknownFailure',
    () {
      final result = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.cancel,
        ),
      );

      expect(
        result,
        isA<UnknownFailure>(),
      );
    },
  );
}