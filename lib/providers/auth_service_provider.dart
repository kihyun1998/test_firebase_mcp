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
