import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:boilerplate/core/constants/api_constants.dart';
import 'package:boilerplate/core/utils/logger.dart';

/// Dio HTTP 클라이언트 설정
///
/// 싱글톤 패턴으로 구현되어 앱 전역에서 하나의 인스턴스만 사용
/// Riverpod Provider를 통해 주입받아 사용하는 것을 권장
abstract final class ApiClient {
  static Dio? _instance;

  /// Dio 싱글톤 인스턴스 반환
  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  /// 테스트용 인스턴스 리셋
  @visibleForTesting
  static void resetInstance() {
    _instance = null;
  }

  static Dio _createDio() {
    final dio = Dio(
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
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      );
    }

    // 커스텀 로거 인터셉터 (프로덕션에서는 AppLogger가 필터링)
    dio.interceptors.add(
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

    return dio;
  }
}
