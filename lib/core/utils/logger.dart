import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// 앱 전역 로깅 유틸리티
///
/// 개발 환경에서는 상세 로그 출력, 프로덕션에서는 최소화
abstract final class AppLogger {
  AppLogger._();

  /// 일반 정보 로그
  static void info(String message, [String? tag]) {
    if (kDebugMode) {
      developer.log(
        message,
        name: tag ?? 'INFO',
        level: 800,
      );
    }
  }

  /// 경고 로그
  static void warning(String message, [String? tag]) {
    if (kDebugMode) {
      developer.log(
        message,
        name: tag ?? 'WARNING',
        level: 900,
      );
    }
  }

  /// 에러 로그 (스택 트레이스 포함)
  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    if (kDebugMode) {
      developer.log(
        message,
        name: tag ?? 'ERROR',
        level: 1000,
        error: error,
        stackTrace: stackTrace,
      );
    }
    // 프로덕션에서는 Crashlytics 등으로 전송
    // FirebaseCrashlytics.instance.recordError(error, stackTrace);
  }

  /// 디버그 로그 (개발 중에만 사용)
  static void debug(String message, [String? tag]) {
    if (kDebugMode) {
      debugPrint('[${tag ?? 'DEBUG'}] $message');
    }
  }

  /// 네트워크 요청 로그
  static void network(String message, {String? method, String? url}) {
    if (kDebugMode) {
      final prefix = method != null ? '[$method]' : '';
      developer.log(
        '$prefix $message',
        name: 'NETWORK',
        level: 800,
      );
    }
  }
}
