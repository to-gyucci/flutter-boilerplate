import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import 'package:boilerplate/core/errors/failures.dart';
import 'package:boilerplate/core/utils/logger.dart';
import 'package:boilerplate/core/utils/typedef.dart';
import 'package:boilerplate/features/home/domain/entities/greeting.dart';
import 'package:boilerplate/features/home/domain/repositories/home_repository.dart';
import 'package:boilerplate/features/home/data/datasources/home_local_data_source.dart';
import 'package:boilerplate/features/home/data/datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final HomeLocalDataSource localDataSource;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  FutureEither<Greeting> getGreeting() async {
    try {
      // 1. 원격 데이터 가져오기
      final remoteGreeting = await remoteDataSource.getGreeting();

      // 2. 로컬에 캐싱
      await localDataSource.cacheGreeting(remoteGreeting);

      // 3. Entity로 변환하여 반환
      return right(remoteGreeting.toEntity());
    } on DioException catch (e) {
      // Dio 네트워크 에러 처리
      AppLogger.error('Network error occurred', error: e, tag: 'Repository');
      return _handleNetworkError(e);
    } on SocketException catch (e) {
      // 인터넷 연결 에러 처리
      AppLogger.error('Socket error occurred', error: e, tag: 'Repository');
      return _handleNetworkError(null);
    } catch (e, stackTrace) {
      // 기타 예상치 못한 에러
      AppLogger.error(
        'Unexpected error in getGreeting',
        error: e,
        stackTrace: stackTrace,
        tag: 'Repository',
      );
      return _handleNetworkError(null);
    }
  }

  /// 네트워크 에러 발생 시 캐시 폴백 처리
  Future<Either<Failure, Greeting>> _handleNetworkError(
    DioException? dioError,
  ) async {
    try {
      final cachedGreeting = await localDataSource.getCachedGreeting();
      if (cachedGreeting != null) {
        AppLogger.info('Using cached data as fallback', 'Repository');
        return right(cachedGreeting.toEntity());
      }
      return left(const Failure.cache(message: 'No cached data available'));
    } catch (cacheError, stackTrace) {
      AppLogger.error(
        'Cache fallback failed',
        error: cacheError,
        stackTrace: stackTrace,
        tag: 'Repository',
      );

      // 원래 네트워크 에러 정보를 반환
      if (dioError != null) {
        return left(_mapDioErrorToFailure(dioError));
      }
      return left(
        const Failure.network(message: 'Network error and no cached data'),
      );
    }
  }

  /// DioException을 Failure로 매핑
  Failure _mapDioErrorToFailure(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const Failure.network(message: 'Connection timeout');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode != null && statusCode >= 500) {
          return Failure.server(
            message: 'Server error: ${error.response?.statusMessage ?? "Unknown"}',
          );
        }
        return Failure.server(
          message: 'Bad response: ${error.response?.statusMessage ?? "Unknown"}',
        );
      case DioExceptionType.cancel:
        return const Failure.network(message: 'Request cancelled');
      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return Failure.network(
          message: error.message ?? 'Unknown network error',
        );
    }
  }
}
