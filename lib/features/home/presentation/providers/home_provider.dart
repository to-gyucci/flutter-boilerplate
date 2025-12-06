import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:boilerplate/core/errors/failures.dart';
import 'package:boilerplate/features/home/data/datasources/home_local_data_source.dart';
import 'package:boilerplate/features/home/data/datasources/home_remote_data_source.dart';
import 'package:boilerplate/features/home/data/repositories/home_repository_impl.dart';
import 'package:boilerplate/features/home/domain/repositories/home_repository.dart';
import 'package:boilerplate/features/home/presentation/providers/home_state.dart';

part 'home_provider.g.dart';

// ============ 의존성 Provider들 ============

/// SharedPreferences 인스턴스 Provider
///
/// main.dart에서 미리 초기화하여 override하므로 동기적으로 사용 가능
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main.dart',
  );
}

@Riverpod(keepAlive: true)
HomeRemoteDataSource homeRemoteDataSource(Ref ref) {
  return HomeRemoteDataSourceImpl();
}

@Riverpod(keepAlive: true)
HomeLocalDataSource homeLocalDataSource(Ref ref) {
  final sharedPrefs = ref.watch(sharedPreferencesProvider);
  return HomeLocalDataSourceImpl(sharedPrefs);
}

@Riverpod(keepAlive: true)
HomeRepository homeRepository(Ref ref) {
  return HomeRepositoryImpl(
    remoteDataSource: ref.watch(homeRemoteDataSourceProvider),
    localDataSource: ref.watch(homeLocalDataSourceProvider),
  );
}

// ============ State Notifier ============

@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  HomeState build() {
    return const HomeState.initial();
  }

  Future<void> loadGreeting() async {
    state = const HomeState.loading();

    // UseCase 없이 Repository 직접 호출
    final result = await ref.read(homeRepositoryProvider).getGreeting();

    state = result.fold(
      (failure) => HomeState.error(
        failure.when(
          server: (message) => 'Server Error: $message',
          network: (message) => 'Network Error: $message',
          cache: (message) => 'Cache Error: $message',
          validation: (message) => 'Validation Error: $message',
          unexpected: (message) => 'Unexpected Error: $message',
        ),
      ),
      (greeting) => HomeState.loaded(greeting),
    );
  }
}
