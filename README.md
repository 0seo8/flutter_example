# injectable_primer

Random Advice API에서 랜덤 조언(advice)을 가져와 화면에 표시하는 앱.

## 사용 API

https://api.adviceslip.com/advice

응답 예시:

{
  "slip": {
    "id": 101,
    "advice": "Always do anything for love, but don't do that"
  }
}

advice 값 접근:

json['slip']['advice']


## 앱의 주요 구성요소

### RandomAdviceRepository

- advice 데이터를 가져오는 기능을 정의하는 추상화(abstraction)
- 실제 API 통신 방법은 구현하지 않음
- RandomAdviceRepositoryImpl이 실제 기능을 구현

예:
abstract class RandomAdviceRepository {
  Future<String> getRandomAdvice();
}


### ApiService

- 실제 HTTP 통신을 담당하는 클래스
- `@singleton`으로 등록 예정
- 앱 시작 시 하나의 인스턴스를 생성하고 이후 같은 인스턴스를 계속 사용

@singleton
class ApiService { ... }

Singleton:
앱에서 하나의 인스턴스를 만들어 여러 곳에서 공유하는 방식.


### http.Client

- `http` 패키지에서 제공하는 외부 클래스
- 우리가 직접 클래스 소스에 `@singleton`, `@lazySingleton` 등의
  annotation을 붙일 수 없음
- 이런 외부 객체를 Injectable에 등록할 때 `@module`을 사용

`@module`은 Injectable에게
"내가 직접 수정할 수 없는 객체는 이런 방식으로 만들어서 등록해"
라고 알려주는 설정 클래스라고 이해하면 됨.


### RandomAdviceRepositoryImpl

- RandomAdviceRepository의 실제 구현체
- `implements RandomAdviceRepository`
- ApiService를 사용하여 실제 advice 데이터를 가져옴
- `@LazySingleton(as: RandomAdviceRepository)` 형태로 등록 예정

RandomAdviceRepository
= 무엇을 할 수 있는지 정의

RandomAdviceRepositoryImpl
= 그것을 실제로 어떻게 할지 구현

LazySingleton:
처음 요청될 때 인스턴스를 하나 생성하고,
그 이후에는 같은 인스턴스를 계속 사용.


### RandomAdviceCubit

- UI 상태를 관리
- RandomAdviceRepository를 사용하여 advice 데이터를 요청
- `@injectable`로 등록 예정

@injectable
class RandomAdviceCubit { ... }

여기서 `@injectable`은 기본적으로 Factory 등록에 대응하므로,
GetIt에서 요청할 때마다 새로운 RandomAdviceCubit 인스턴스를 생성.

### 패키지 설치

**일반 dependencies:**

```bash
flutter pub add injectable get_it bloc flutter_bloc equatable http
```

| 패키지 | 역할 |
|---|---|
| `get_it` | 의존성 객체를 등록해두고 필요한 곳에서 가져올 수 있게 해주는 Service Locator |
| `injectable` | `@injectable`, `@singleton`, `@lazySingleton` 등의 annotation을 사용해 GetIt 등록 방식을 정의 |
| `bloc` | Bloc / Cubit을 이용한 상태 관리 기능 제공 |
| `flutter_bloc` | Bloc / Cubit을 Flutter Widget과 연결 |
| `equatable` | 객체를 인스턴스가 아닌 값 기준으로 비교하기 쉽게 해주는 패키지 |
| `http` | HTTP 요청을 보내 API와 통신하기 위한 패키지 |

**개발용 dependencies:**
```bash
flutter pub add --dev build_runner injectable_generator
```

| 패키지 | 역할 |
|---|---|
| `injectable_generator` | Injectable annotation을 분석해서 GetIt 등록 코드를 자동 생성 |
| `build_runner` | `injectable_generator` 같은 코드 생성기를 실제로 실행 |


## 프로젝트 구조

```text
lib/
├─ di/
│  └─ di.dart
│
├─ domain/
│  └─ repositories/
│     └─ random_advice_repository.dart
│
├─ data/
│  ├─ repositories/
│  │  └─ random_advice_repository_impl.dart
│  │
│  └─ datasources/
│     └─ api_service.dart
│
└─ presentation/
   ├─ blocs/
   │  └─ random_advice/
   │     └─ random_advice_cubit.dart
   │
   └─ pages/
      └─ random_advice_page.dart
```

### 각 레이어의 역할

| 레이어 | 역할 |
| --- | --- |
| `presentation` | 화면과 UI 상태 관리 |
| `domain` | 앱에서 필요한 기능의 규칙/추상화 정의 |
| `data` | Domain에서 정의한 기능을 실제 API/데이터를 이용해 구현 |
| `di` | GetIt + Injectable을 이용해 객체와 의존성을 연결 |

### 주요 클래스

| 클래스 | 역할 |
| --- | --- |
| `RandomAdvicePage` | 사용자가 보는 화면 |
| `RandomAdviceCubit` | 화면의 상태와 동작 관리 |
| `RandomAdviceRepository` | 랜덤 advice를 가져오는 기능의 규칙 정의 |
| `RandomAdviceRepositoryImpl` | Repository의 실제 구현 |
| `ApiService` | 실제 HTTP API 통신 |

### 데이터 흐름

```text
RandomAdvicePage
        │
        ▼
RandomAdviceCubit
        │
        ▼
RandomAdviceRepository
        │
        ▼
RandomAdviceRepositoryImpl
        │
        ▼
ApiService
        │
        ▼
Random Advice API
```

레이어 기준으로 보면:

```text
presentation
화면 / 상태 관리
        ↓
domain
필요한 기능의 규칙
        ↓
data
실제 구현 / API 통신
        ↓
외부 API
```

### Repository와 RepositoryImpl을 나누는 이유

`RandomAdviceRepository`는 **무엇을 할 수 있어야 하는지**를 정의한다.

```dart
abstract class RandomAdviceRepository {
  Future<String> getRandomAdvice();
}
```

`RandomAdviceRepositoryImpl`은 그 기능을 **실제로 어떻게 수행할지** 구현한다.

```dart
@LazySingleton(as: RandomAdviceRepository)
class RandomAdviceRepositoryImpl
    implements RandomAdviceRepository {
  ...
}
```

즉,

```text
RandomAdviceRepository
→ 규칙 / 추상화

RandomAdviceRepositoryImpl
→ 실제 구현
```

으로 역할을 분리한다.# flutter_example
