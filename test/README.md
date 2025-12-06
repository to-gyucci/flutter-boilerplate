# 테스트 가이드

## 테스트 구조

```
test/
├── features/
│   └── home/
│       ├── domain/          # Entity 테스트
│       ├── data/            # Model, Repository 테스트
│       └── presentation/    # Provider, Widget 테스트
└── README.md
```

## 테스트 실행

```bash
# 모든 테스트 실행
flutter test

# 특정 파일 테스트
flutter test test/features/home/domain/greeting_test.dart

# 커버리지와 함께 실행
flutter test --coverage

# 커버리지 HTML 리포트 생성 (lcov 필요)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 테스트 작성 가이드

### 1. Domain Layer (Entity) 테스트
- Freezed 생성 메서드 테스트
- copyWith 동작 확인
- Value equality 확인

### 2. Data Layer (Model, Repository) 테스트
- JSON serialization/deserialization
- toEntity() 변환 로직
- Repository 에러 핸들링

### 3. Presentation Layer 테스트
- Provider 상태 변화
- Widget 렌더링
- 사용자 인터랙션

## Mock 사용

Mockito를 사용해서 의존성을 Mock합니다:

```dart
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([HomeRepository])
void main() {
  late MockHomeRepository mockRepository;

  setUp(() {
    mockRepository = MockHomeRepository();
  });

  test('should return Greeting when repository call is successful', () async {
    // Arrange
    when(mockRepository.getGreeting())
        .thenAnswer((_) async => right(tGreeting));

    // Act & Assert
    // ...
  });
}
```

## 테스트 커버리지 목표

- Domain Layer: 100%
- Data Layer: 80% 이상
- Presentation Layer: 70% 이상
