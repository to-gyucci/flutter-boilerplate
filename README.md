# Flutter Clean Architecture Boilerplate

## ✨ 주요 특징

- ✅ **Clean Architecture** - Domain, Data, Presentation 레이어 분리
- ✅ **Riverpod 3.0** - 최신 상태관리 (코드 생성 방식)
- ✅ **Freezed** - 불변 객체 및 Union Types
- ✅ **fpdart** - 함수형 프로그래밍 (Either 패턴)
- ✅ **GoRouter** - 타입 안전한 선언적 라우팅
- ✅ **Dio + Retrofit** - 타입 안전한 HTTP 클라이언트
- ✅ **로깅 시스템** - 개발/프로덕션 환경별 로깅
- ✅ **에러 핸들링** - DioException, SocketException 등 구체적 처리
- ✅ **테스트 구조** - 유닛/위젯 테스트 기본 구조

## 📁 프로젝트 구조

```
lib/
├── core/                      # 공통 모듈
│   ├── constants/            # 상수 정의
│   ├── errors/               # 에러 및 예외
│   ├── network/              # HTTP 클라이언트
│   ├── theme/                # 앱 테마
│   ├── utils/                # 유틸리티
│   └── widgets/              # 공통 위젯
├── features/                 # Feature-first 구조
│   └── home/
│       ├── data/
│       │   ├── datasources/  # Remote/Local 데이터 소스
│       │   ├── models/       # JSON 모델 (+ toEntity)
│       │   └── repositories/ # Repository 구현체
│       ├── domain/
│       │   ├── entities/     # 비즈니스 엔티티
│       │   └── repositories/ # Repository 인터페이스
│       └── presentation/
│           ├── pages/        # UI 페이지
│           ├── providers/    # Riverpod State
│           └── widgets/      # Feature 위젯
├── routing/                  # 라우팅 설정
│   ├── app_router.dart
│   └── routes.dart
└── main.dart
```

## 🚀 시작하기

### 1. 의존성 설치

```bash
flutter pub get
```

### 2. 코드 생성

```bash
# Freezed, Riverpod, JSON Serialization 코드 생성
dart run build_runner build --delete-conflicting-outputs

# Watch 모드 (개발 중)
dart run build_runner watch --delete-conflicting-outputs
```

### 3. 실행

```bash
flutter run
```

## 🧪 테스트

```bash
# 모든 테스트 실행
flutter test

# 커버리지와 함께
flutter test --coverage

# 특정 테스트만
flutter test test/features/home/domain/greeting_test.dart
```

## 📦 주요 패키지

### Production
- `flutter_riverpod` - 상태관리
- `riverpod_annotation` - Riverpod 코드 생성
- `fpdart` - 함수형 프로그래밍
- `freezed_annotation` - 불변 객체
- `go_router` - 라우팅
- `dio` - HTTP 클라이언트
- `retrofit` - REST API 클라이언트
- `shared_preferences` - 로컬 저장소

### Development
- `build_runner` - 코드 생성 러너
- `freezed` - Freezed 코드 생성
- `riverpod_generator` - Riverpod 코드 생성
- `json_serializable` - JSON 직렬화
- `mockito` - 테스트 Mock

## 🎯 개발 가이드

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

2. **Entity 정의** (domain/entities/)
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

3. **Repository 인터페이스** (domain/repositories/)
```dart
abstract class MyRepository {
  FutureEither<MyEntity> getData();
}
```

4. **Provider 생성** (presentation/providers/)
```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_provider.g.dart';

@riverpod
class MyNotifier extends _$MyNotifier {
  @override
  MyState build() => const MyState.initial();

  Future<void> loadData() async {
    // 로직 구현
  }
}
```

5. **코드 생성**
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Freezed Extension Import 주의사항

Freezed 3.x는 `when`, `map` 같은 메서드를 extension으로 생성합니다.
사용하려면 **반드시 해당 파일을 명시적으로 import** 해야 합니다:

```dart
// ❌ 틀림 - when 메서드 못 찾음
import '../providers/home_provider.dart';

// ✅ 맞음 - extension 사용 가능
import '../providers/home_provider.dart';
import '../providers/home_state.dart';  // 이 import 필요!
```

## 🔧 코드 스타일

이 프로젝트는 엄격한 분석 옵션을 사용합니다 (`analysis_options.yaml`):

- `strict-casts: true`
- `strict-inference: true`
- `prefer_const_constructors: true`
- `always_use_package_imports: true`

## 🛡️ 프로덕션 안전성

### 1. SharedPreferences 초기화
앱 시작 시 SharedPreferences를 미리 초기화하여 크래시 방지:
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
Repository 레이어에서 DioException, SocketException 등을 개별 처리하고,
네트워크 에러 시 캐시 폴백을 자동으로 시도합니다.

### 3. 로깅 시스템
`AppLogger` 유틸리티를 통해 개발 환경에서는 상세 로그,
프로덕션에서는 민감 정보를 제외한 필수 로그만 기록:
```dart
// 정보 로그
AppLogger.info('User logged in', 'Auth');

// 에러 로그
AppLogger.error('Failed to fetch data', error: e, stackTrace: st);

// 네트워크 로그
AppLogger.network('https://api.example.com/data', method: 'GET');
```

### 4. 보안
- PrettyDioLogger는 개발 환경(`kDebugMode`)에서만 활성화
- 프로덕션에서는 커스텀 로거로 민감 정보 노출 방지