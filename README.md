# Flutter Clean Architecture Boilerplate

Production-ready Flutter 보일러플레이트입니다. Clean Architecture, Riverpod 3.0, Freezed를 기반으로 확장 가능하고 테스트 가능한 앱 개발을 위한 템플릿을 제공합니다.

## 주요 특징

| 기능 | 설명 |
|------|------|
| **Clean Architecture** | Domain, Data, Presentation 3-레이어 분리 |
| **Riverpod 3.0** | 최신 코드 생성 방식 상태관리 |
| **Freezed** | 불변 객체 및 Sealed Union Types |
| **fpdart** | 함수형 프로그래밍 (Either 패턴) |
| **GoRouter** | 타입 안전한 선언적 라우팅 |
| **Dio + Retrofit** | 타입 안전한 HTTP 클라이언트 |
| **에러 핸들링** | DioException, SocketException 등 구체적 처리 + 캐시 폴백 |
| **로깅 시스템** | 개발/프로덕션 환경별 로깅 |
| **테스트 구조** | 유닛/위젯 테스트 기본 구조 |

## 프로젝트 구조

```
lib/
├── core/                          # 공통 인프라
│   ├── constants/                 # 상수 정의
│   │   └── api_constants.dart
│   ├── errors/                    # 에러 타입
│   │   └── failures.dart          # Sealed Failure 타입
│   ├── network/                   # HTTP 클라이언트
│   │   └── api_client.dart        # Dio 싱글톤 설정
│   ├── theme/                     # 앱 테마
│   │   └── app_theme.dart         # Material 3 Light/Dark
│   ├── utils/                     # 유틸리티
│   │   ├── logger.dart            # 환경별 로깅
│   │   └── typedef.dart           # FutureEither 타입 별칭
│   └── widgets/                   # 공통 위젯
│
├── features/                      # Feature-first 구조
│   └── home/                      # 샘플 Feature
│       ├── data/
│       │   ├── datasources/       # Remote/Local 데이터 소스
│       │   ├── models/            # JSON 모델 (+ toEntity)
│       │   └── repositories/      # Repository 구현체
│       ├── domain/
│       │   ├── entities/          # 비즈니스 엔티티
│       │   └── repositories/      # Repository 인터페이스
│       └── presentation/
│           ├── pages/             # UI 페이지
│           ├── providers/         # Riverpod State
│           └── widgets/           # Feature 위젯
│
├── routing/                       # 라우팅 설정
│   ├── app_router.dart            # GoRouter 설정
│   └── routes.dart                # 라우트 상수
│
└── main.dart                      # 앱 진입점
```

## 시작하기

### 요구사항

- Flutter SDK: ^3.10.1
- Dart SDK: ^3.10.1

### 1. 의존성 설치

```bash
flutter pub get
```

### 2. 코드 생성

```bash
# Freezed, Riverpod, JSON Serialization 코드 생성
dart run build_runner build --delete-conflicting-outputs

# Watch 모드 (개발 중 자동 생성)
dart run build_runner watch --delete-conflicting-outputs
```

### 3. 실행

```bash
flutter run
```

## 테스트

```bash
# 모든 테스트 실행
flutter test

# 커버리지와 함께
flutter test --coverage

# 특정 테스트만
flutter test test/features/home/domain/greeting_test.dart
```

### 테스트 커버리지 목표

- Domain Layer: 100%
- Data Layer: 80%+
- Presentation Layer: 70%+

## 주요 패키지

### Production

| 패키지 | 용도 |
|--------|------|
| `flutter_riverpod` | 상태관리 |
| `riverpod_annotation` | Riverpod 코드 생성 |
| `fpdart` | 함수형 프로그래밍 (Either) |
| `freezed_annotation` | 불변 객체 |
| `go_router` | 선언적 라우팅 |
| `dio` | HTTP 클라이언트 |
| `retrofit` | REST API 클라이언트 |
| `shared_preferences` | 로컬 저장소 |
| `flutter_screenutil` | 반응형 UI |

### Development

| 패키지 | 용도 |
|--------|------|
| `build_runner` | 코드 생성 러너 |
| `freezed` | Freezed 코드 생성 |
| `riverpod_generator` | Riverpod 코드 생성 |
| `json_serializable` | JSON 직렬화 |
| `mockito` | 테스트 Mock |

## 아키텍처 가이드

### Clean Architecture 3-레이어

```
┌─────────────────────────────────────────────────────────┐
│                   Presentation Layer                     │
│              (Pages, Providers, Widgets)                 │
│                         │                                │
│                         ▼                                │
├─────────────────────────────────────────────────────────┤
│                    Domain Layer                          │
│              (Entities, Repository Interfaces)           │
│                         ▲                                │
│                         │                                │
├─────────────────────────────────────────────────────────┤
│                     Data Layer                           │
│    (DataSources, Models, Repository Implementations)     │
└─────────────────────────────────────────────────────────┘
```

### Either 패턴 (에러 핸들링)

예외를 던지지 않고 `Either<Failure, Success>`로 에러를 값으로 처리합니다:

```dart
// Repository 정의
FutureEither<Greeting> getGreeting();

// 사용 예시
final result = await repository.getGreeting();
result.fold(
  (failure) => state = HomeState.error(failure.message),
  (greeting) => state = HomeState.loaded(greeting),
);
```

### Sealed Failure 타입

타입 안전한 에러 처리를 위한 Sealed Class:

```dart
@Freezed()
sealed class Failure with _$Failure {
  const factory Failure.server({required String message}) = ServerFailure;
  const factory Failure.cache({required String message}) = CacheFailure;
  const factory Failure.network({required String message}) = NetworkFailure;
  const factory Failure.validation({required String message}) = ValidationFailure;
  const factory Failure.unexpected({required String message}) = UnexpectedFailure;
}
```

## 개발 가이드

### 새 Feature 추가

1. **폴더 구조 생성**

```bash
lib/features/my_feature/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   └── repositories/
└── presentation/
    ├── pages/
    ├── providers/
    └── widgets/
```

2. **Entity 정의** (`domain/entities/my_entity.dart`)

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_entity.freezed.dart';

@freezed
abstract class MyEntity with _$MyEntity {
  const MyEntity._();

  const factory MyEntity({
    required String id,
    required String name,
  }) = _MyEntity;
}
```

3. **Repository 인터페이스** (`domain/repositories/my_repository.dart`)

```dart
import 'package:boilerplate/core/utils/typedef.dart';

abstract class MyRepository {
  FutureEither<MyEntity> getData();
}
```

4. **Model 생성** (`data/models/my_model.dart`)

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:boilerplate/features/my_feature/domain/entities/my_entity.dart';

part 'my_model.freezed.dart';
part 'my_model.g.dart';

@freezed
abstract class MyModel with _$MyModel {
  const MyModel._();

  const factory MyModel({
    required String id,
    required String name,
  }) = _MyModel;

  factory MyModel.fromJson(Map<String, dynamic> json) => _$MyModelFromJson(json);

  MyEntity toEntity() => MyEntity(id: id, name: name);
}
```

5. **Provider 생성** (`presentation/providers/my_provider.dart`)

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_provider.g.dart';

@riverpod
class MyNotifier extends _$MyNotifier {
  @override
  MyState build() => const MyState.initial();

  Future<void> loadData() async {
    state = const MyState.loading();
    final result = await ref.read(myRepositoryProvider).getData();
    state = result.fold(
      (failure) => MyState.error(failure.message),
      (data) => MyState.loaded(data),
    );
  }
}
```

6. **코드 생성**

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Freezed Extension Import 주의사항

Freezed 3.x는 `when`, `map` 같은 메서드를 extension으로 생성합니다. 반드시 해당 파일을 명시적으로 import 해야 합니다:

```dart
// State 파일의 when/map 사용 시
import '../providers/home_provider.dart';
import '../providers/home_state.dart';  // 이 import가 필요!
```

## 프로덕션 안전성

### 1. SharedPreferences 초기화

앱 시작 시 미리 초기화하여 크래시 방지:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}
```

### 2. 에러 핸들링

Repository 레이어에서 DioException, SocketException 등을 개별 처리하고, 네트워크 에러 시 캐시 폴백을 자동으로 시도합니다.

### 3. 환경별 로깅

| 환경 | PrettyDioLogger | GoRouter 디버그 | AppLogger |
|------|-----------------|-----------------|-----------|
| 개발 | 활성화 | 활성화 | 상세 로그 |
| 프로덕션 | 비활성화 | 비활성화 | 최소 로그 |

```dart
// 정보 로그
AppLogger.info('User logged in', 'Auth');

// 에러 로그 (스택 트레이스 포함)
AppLogger.error('Failed to fetch data', error: e, stackTrace: st);

// 네트워크 로그
AppLogger.network('https://api.example.com/data', method: 'GET');
```

## 코드 스타일

이 프로젝트는 엄격한 분석 옵션을 사용합니다 (`analysis_options.yaml`):

- `strict-casts: true`
- `strict-inference: true`
- `strict-raw-types: true`
- `prefer_const_constructors: true`
- `always_use_package_imports: true`

## 라이선스

MIT License
