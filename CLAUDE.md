# CLAUDE.md

이 파일은 Claude Code가 이 프로젝트에서 작업할 때 참고하는 컨텍스트 문서입니다.

## 프로젝트 개요

Flutter Clean Architecture 보일러플레이트 프로젝트입니다. Feature-first 구조와 3-레이어 아키텍처를 적용하여 확장 가능하고 테스트 가능한 앱 개발을 위한 템플릿을 제공합니다.

## 기술 스택

- **Flutter**: ^3.10.1 (Dart ^3.10.1)
- **상태관리**: Riverpod 3.0 (코드 생성 방식)
- **불변 객체**: Freezed 3.x
- **함수형 프로그래밍**: fpdart (Either 패턴)
- **라우팅**: GoRouter 17.0
- **HTTP 클라이언트**: Dio + Retrofit
- **로컬 저장소**: SharedPreferences
- **UI**: Material Design 3, flutter_screenutil

## 프로젝트 구조

```
lib/
├── core/                          # 공통 인프라
│   ├── constants/api_constants.dart    # API 엔드포인트
│   ├── errors/failures.dart            # Sealed Failure 타입
│   ├── network/api_client.dart         # Dio HTTP 클라이언트 (싱글톤)
│   ├── theme/app_theme.dart            # Material 3 테마
│   ├── utils/
│   │   ├── logger.dart                 # 환경별 로깅
│   │   └── typedef.dart                # FutureEither 타입 별칭
│   └── widgets/                        # 공통 위젯 (확장 가능)
├── features/                           # Feature-first 구조
│   └── [feature_name]/
│       ├── data/
│       │   ├── datasources/            # Remote/Local 데이터 소스
│       │   ├── models/                 # JSON 모델 (+ toEntity)
│       │   └── repositories/           # Repository 구현체
│       ├── domain/
│       │   ├── entities/               # 비즈니스 엔티티
│       │   └── repositories/           # Repository 인터페이스
│       └── presentation/
│           ├── pages/                  # UI 페이지
│           ├── providers/              # Riverpod 상태
│           └── widgets/                # Feature 위젯
├── routing/
│   ├── app_router.dart                 # GoRouter 설정
│   └── routes.dart                     # 라우트 상수
└── main.dart                           # 앱 진입점
```

## 빌드 & 실행 명령어

```bash
# 의존성 설치
flutter pub get

# 코드 생성 (Freezed, Riverpod, JSON)
dart run build_runner build --delete-conflicting-outputs

# 개발 중 Watch 모드
dart run build_runner watch --delete-conflicting-outputs

# 앱 실행
flutter run

# 테스트 실행
flutter test

# 커버리지 포함 테스트
flutter test --coverage
```

## 핵심 아키텍처 패턴

### 1. Clean Architecture 3-레이어

- **Domain Layer**: 순수 비즈니스 로직 (entities, repository interfaces)
- **Data Layer**: 외부 데이터 처리 (datasources, models, repository implementations)
- **Presentation Layer**: UI 상태 관리 (pages, providers, widgets)

### 2. Either 패턴 (에러 핸들링)

```dart
// typedef 정의
typedef FutureEither<T> = Future<Either<Failure, T>>;

// 사용 예시
final result = await repository.getData();
result.fold(
  (failure) => handleError(failure),
  (data) => handleSuccess(data),
);
```

### 3. Sealed Failure 타입

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

### 4. Riverpod Provider 구조

```dart
// 의존성 Provider (keepAlive로 싱글톤)
@Riverpod(keepAlive: true)
HomeRepository homeRepository(Ref ref) {
  return HomeRepositoryImpl(
    remoteDataSource: ref.watch(homeRemoteDataSourceProvider),
    localDataSource: ref.watch(homeLocalDataSourceProvider),
  );
}

// State Notifier
@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  HomeState build() => const HomeState.initial();

  Future<void> loadData() async { /* ... */ }
}
```

## 주요 코딩 컨벤션

### Freezed Extension Import

Freezed 3.x에서 `when`, `map` 메서드는 extension으로 생성됩니다. 해당 파일을 명시적으로 import해야 합니다:

```dart
// State 파일도 import 필요
import '../providers/home_provider.dart';
import '../providers/home_state.dart';  // when/map 사용 시 필요
```

### 클래스 스타일

- 유틸리티 클래스: `abstract final class` + 프라이빗 생성자
- Provider에서 관리되는 의존성: Repository, DataSource 등

### 에러 처리 규칙

1. Repository에서 모든 예외를 `Failure`로 변환
2. DioException, SocketException 등 구체적 처리
3. 네트워크 실패 시 캐시 폴백 시도

## 테스트 구조

```
test/
├── features/
│   └── [feature_name]/
│       ├── domain/          # Entity 테스트
│       ├── data/            # Model, Repository 테스트
│       └── presentation/    # Provider, Widget 테스트
└── README.md                # 테스트 가이드
```

### 테스트 커버리지 목표

- Domain Layer: 100%
- Data Layer: 80%+
- Presentation Layer: 70%+

## 새 Feature 추가 시 체크리스트

1. [ ] `lib/features/[feature_name]/` 폴더 구조 생성
2. [ ] Domain: Entity 정의 (Freezed)
3. [ ] Domain: Repository 인터페이스 정의
4. [ ] Data: Model 생성 (JSON serialization + toEntity)
5. [ ] Data: Remote/Local DataSource 구현
6. [ ] Data: Repository 구현체 작성
7. [ ] Presentation: State 정의 (Freezed sealed class)
8. [ ] Presentation: Provider 생성 (Riverpod annotation)
9. [ ] Presentation: Page/Widget 구현
10. [ ] Routing: 라우트 추가 (`routes.dart`, `app_router.dart`)
11. [ ] 코드 생성 실행: `dart run build_runner build --delete-conflicting-outputs`
12. [ ] 테스트 작성

## 환경별 동작

### 개발 환경 (kDebugMode = true)

- PrettyDioLogger 활성화 (상세 HTTP 로그)
- GoRouter 디버그 로그 출력
- AppLogger 상세 로그 출력

### 프로덕션 환경 (kDebugMode = false)

- PrettyDioLogger 비활성화
- GoRouter 디버그 로그 비활성화
- AppLogger 최소 로그 (Crashlytics 연동 가능)

## 주의사항

- **SharedPreferences**: `main.dart`에서 미리 초기화 후 ProviderScope에서 override
- **코드 생성 파일**: `.g.dart`, `.freezed.dart`는 git에서 제외 (`.gitignore`)
- **Strict Lint**: `analysis_options.yaml`에서 엄격한 규칙 적용
- **API 보안**: 프로덕션에서는 민감 정보 로깅 금지
