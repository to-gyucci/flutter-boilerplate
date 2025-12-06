import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:boilerplate/core/constants/api_constants.dart';
import 'package:boilerplate/core/utils/logger.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // PrettyDioLogger는 개발 환경에서만 활성화
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      );
    }

    // 프로덕션 환경에서는 커스텀 로거 사용
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          AppLogger.network(
            '${options.uri}',
            method: options.method,
            url: options.path,
          );
          handler.next(options);
        },
        onError: (error, handler) {
          AppLogger.error(
            'Network Error: ${error.message}',
            error: error,
            stackTrace: error.stackTrace,
            tag: 'API',
          );
          handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
