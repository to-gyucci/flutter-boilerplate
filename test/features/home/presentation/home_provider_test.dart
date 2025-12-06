import 'package:boilerplate/features/home/presentation/providers/home_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeNotifier', () {
    test('HomeState should support equality', () {
      // Arrange
      const state1 = HomeState.initial();
      const state2 = HomeState.initial();

      // Assert
      expect(state1, state2);
    });

    // TODO: Repository를 Mock해서 성공/실패 케이스 테스트 추가
    // Mockito를 사용한 테스트 예제는 아래 주석 참고:
    //
    // test('loadGreeting should emit loading then loaded on success', () async {
    //   // Arrange
    //   final mockRepository = MockHomeRepository();
    //   when(mockRepository.getGreeting()).thenAnswer(
    //     (_) async => right(const Greeting(
    //       message: 'Test',
    //       timestamp: '2025-12-06',
    //     )),
    //   );
    //
    //   final container = ProviderContainer(
    //     overrides: [
    //       homeRepositoryProvider.overrideWithValue(mockRepository),
    //     ],
    //   );
    //
    //   // Act
    //   await container.read(homeProviderProvider.notifier).loadGreeting();
    //
    //   // Assert
    //   final state = container.read(homeProviderProvider);
    //   expect(state, isA<_Loaded>());
    //
    //   container.dispose();
    // });
  });
}
