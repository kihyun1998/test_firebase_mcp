# Firebase MCP를 사용한 Flutter 로그인 및 푸시 알림 구현 프로젝트

## 프로젝트 개요
Flutter 모바일 앱에서 Firebase MCP를 활용하여 로그인 기능과 푸시 알림 기능을 구현하는 예제 프로젝트입니다.

## 기술 스택
- **Framework**: Flutter (SDK 3.8.1)
- **상태 관리**: Riverpod (riverpod_generator 사용, freezed는 사용하지 않음)
- **Backend**: Firebase (Authentication, Cloud Messaging)
- **AI 도구**: Firebase MCP Server (Claude Code와 연동)

## 완료된 작업

### 1. ✅ 프로젝트 초기 설정
- Flutter 프로젝트 생성 완료
- 프로젝트명: `test_firebase_mcp`
- 위치: `E:\test_firebase_mcp`

### 2. ✅ 패키지 설치
다음 패키지가 `pubspec.yaml`에 추가되고 설치됨:

**Dependencies:**
- `firebase_core: ^3.8.1` - Firebase 초기화
- `firebase_auth: ^5.3.4` - 인증 기능
- `firebase_messaging: ^15.1.5` - 푸시 알림
- `flutter_riverpod: ^2.6.1` - Riverpod 상태 관리
- `riverpod_annotation: ^2.6.1` - Riverpod 코드 생성 어노테이션

**Dev Dependencies:**
- `build_runner: ^2.4.14` - 코드 생성 도구
- `riverpod_generator: ^2.6.2` - Riverpod Provider 자동 생성
- `riverpod_lint: ^2.6.3` - Riverpod 린트 규칙

### 3. ✅ Firebase MCP 서버 설정
- `.mcp.json` 파일 생성
- Windows 환경에 맞게 `cmd /c` wrapper 추가 완료
```json
{
  "mcpServers": {
    "firebase": {
      "command": "cmd",
      "args": ["/c", "npx", "-y", "firebase-tools@latest", "mcp"]
    }
  }
}
```

## 다음 단계 (MCP 서버 연결 후 진행할 작업)

### 4. Firebase 프로젝트 생성 및 설정
- [ ] Firebase MCP를 통해 Firebase Console에서 프로젝트 생성
- [ ] Android 앱 등록 (패키지명: `com.example.test_firebase_mcp`)
- [ ] iOS 앱 등록 (Bundle ID 설정)
- [ ] `google-services.json` 다운로드 및 `android/app/` 경로에 배치
- [ ] `GoogleService-Info.plist` 다운로드 및 `ios/Runner/` 경로에 배치
- [ ] Firebase Authentication 활성화 (이메일/비밀번호 로그인)
- [ ] Firebase Cloud Messaging 활성화

### 5. Firebase 초기화 코드 작성
- [ ] `lib/main.dart` 수정
  - Firebase 초기화 (`Firebase.initializeApp()`)
  - ProviderScope로 앱 감싸기
  - 기본 앱 구조 설정

### 6. 프로젝트 구조 설계
```
lib/
├── main.dart
├── providers/
│   ├── auth_provider.dart (riverpod generator 사용)
│   └── fcm_provider.dart (riverpod generator 사용)
├── models/
│   └── user_model.dart
├── services/
│   ├── auth_service.dart
│   └── fcm_service.dart
└── screens/
    ├── login_screen.dart
    ├── home_screen.dart
    └── register_screen.dart
```

### 7. 로그인 기능 구현 (이메일/비밀번호)
- [ ] `AuthService` 클래스 작성
  - 이메일/비밀번호 로그인
  - 회원가입
  - 로그아웃
  - 인증 상태 스트림
- [ ] `AuthProvider` 작성 (riverpod_generator 사용)
  - 현재 사용자 상태 관리
  - 로그인/로그아웃 액션
- [ ] `LoginScreen` UI 작성
  - 이메일/비밀번호 입력 폼
  - 로그인 버튼
  - 회원가입 화면 이동 버튼
- [ ] `RegisterScreen` UI 작성
  - 회원가입 폼
- [ ] `HomeScreen` 작성
  - 로그인 후 표시될 화면
  - 사용자 정보 표시
  - 로그아웃 버튼

### 8. 푸시 알림 기능 구현
- [ ] Android 설정
  - `android/app/build.gradle` Firebase 플러그인 추가
  - 권한 설정
- [ ] iOS 설정
  - APNs 인증서 설정 (개발용)
  - `ios/Runner/Info.plist` 권한 추가
- [ ] `FCMService` 클래스 작성
  - FCM 토큰 가져오기
  - 토큰 갱신 리스너
  - Foreground 메시지 수신
  - Background 메시지 수신
  - 알림 권한 요청
- [ ] `FCMProvider` 작성 (riverpod_generator 사용)
  - FCM 토큰 상태 관리
  - 메시지 수신 상태 관리
- [ ] 테스트 알림 전송 기능
  - Firebase Console에서 테스트 메시지 전송
  - 앱에서 수신 확인

### 9. 코드 생성 및 테스트
- [ ] `dart run build_runner build --delete-conflicting-outputs` 실행
- [ ] 로그인/로그아웃 테스트
- [ ] 푸시 알림 수신 테스트 (Foreground/Background)

### 10. 추가 개선 사항 (선택)
- [ ] Google 로그인 추가
- [ ] 로딩 상태 UI 추가
- [ ] 에러 처리 개선
- [ ] 알림 클릭 시 특정 화면으로 이동
- [ ] 로컬 알림 저장

## 주의 사항
1. **Freezed 사용하지 않음**: 일반 Dart 클래스로 모델 작성
2. **Riverpod Generator 사용**: `@riverpod` 어노테이션으로 Provider 생성
3. **Firebase MCP 활용**: AI가 Firebase 설정을 자동화하도록 MCP 서버 사용
4. **Windows 환경**: PowerShell에서 작업 중, 경로 구분자 주의

## 다음 세션 시작 질문 예시
"Firebase MCP를 사용해서 Flutter 프로젝트에 Firebase 프로젝트를 생성하고 연결하고 싶어.
이미 .mcp.json에 Firebase MCP 서버 설정이 되어있고, pubspec.yaml에 firebase_core, firebase_auth, firebase_messaging 패키지가 추가되어있어.
Riverpod generator를 사용해서 상태관리할거고, freezed는 사용하지 않을거야.
로그인(이메일/비밀번호)과 푸시 알림 기능을 구현해줘."
