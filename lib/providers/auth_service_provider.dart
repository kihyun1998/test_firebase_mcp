import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

part 'auth_service_provider.g.dart';

// AuthService Provider
@Riverpod(dependencies: [])
AuthService authService(Ref ref) {
  return AuthService();
}

// 인증 상태 스트림 Provider
@Riverpod(dependencies: [authService])
Stream<User?> authStateChanges(Ref ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
}

// 현재 사용자 Provider
@Riverpod(dependencies: [authStateChanges])
UserModel? currentUser(Ref ref) {
  final authState = ref.watch(authStateChangesProvider);

  return authState.when(
    data: (user) {
      if (user == null) return null;
      return UserModel.fromFirebaseUser(user);
    },
    loading: () => null,
    error: (_, __) => null,
  );
}

// Google Access Token Provider
@Riverpod(dependencies: [authService])
String? accessToken(Ref ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.accessToken;
}

// 로그인 액션을 위한 Notifier
@Riverpod(dependencies: [authService])
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {
    // 초기 상태는 아무것도 하지 않음
  }

  // 이메일/비밀번호 회원가입
  Future<void> signUp({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authService = ref.read(authServiceProvider);
      await authService.signUpWithEmail(email: email, password: password);
    });
  }

  // 이메일/비밀번호 로그인
  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithEmail(email: email, password: password);
    });
  }

  // Google 로그인
  Future<void> signInWithGoogle() async {
    print('🟡 AuthController: Google 로그인 시작');
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authService = ref.read(authServiceProvider);
      final result = await authService.signInWithGoogle();
      print('🟡 AuthController: signInWithGoogle 결과 = $result');
    });
    print('🟡 AuthController: 최종 state = ${state.hasError ? "에러: ${state.error}" : "성공"}');
  }

  // 로그아웃
  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authService = ref.read(authServiceProvider);
      await authService.signOut();
    });
  }

  // 비밀번호 재설정 이메일 전송
  Future<void> sendPasswordResetEmail(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authService = ref.read(authServiceProvider);
      await authService.sendPasswordResetEmail(email);
    });
  }
}

// ID Token Provider
@Riverpod(dependencies: [authService])
Future<String?> idToken(Ref ref) async {
  final authService = ref.watch(authServiceProvider);
  return await authService.getIDToken();
}

// ID Token 갱신을 위한 Controller
@Riverpod(dependencies: [authService])
class IdTokenController extends _$IdTokenController {
  @override
  FutureOr<void> build() {
    // 초기 상태
  }

  // ID Token 갱신
  Future<String?> refreshIDToken() async {
    state = const AsyncLoading();
    try {
      final authService = ref.read(authServiceProvider);
      final token = await authService.getIDToken(forceRefresh: true);
      state = const AsyncData(null);

      // idTokenProvider를 무효화하여 새로 가져오도록 함
      ref.invalidate(idTokenProvider);

      return token;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return null;
    }
  }
}

// Access Token 갱신을 위한 Controller
@Riverpod(dependencies: [authService])
class AccessTokenController extends _$AccessTokenController {
  @override
  FutureOr<void> build() {
    // 초기 상태
  }

  // Access Token 갱신
  Future<String?> refreshAccessToken() async {
    state = const AsyncLoading();
    try {
      final authService = ref.read(authServiceProvider);
      final token = await authService.refreshAccessToken();
      state = const AsyncData(null);

      // accessTokenProvider를 무효화하여 새로 가져오도록 함
      ref.invalidate(accessTokenProvider);

      return token;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return null;
    }
  }
}
