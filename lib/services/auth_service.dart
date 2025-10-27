import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 현재 사용자 스트림
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 현재 사용자
  User? get currentUser => _auth.currentUser;

  // 현재 사용자 모델
  UserModel? get currentUserModel {
    final user = currentUser;
    if (user == null) return null;
    return UserModel.fromFirebaseUser(user);
  }

  // 이메일/비밀번호 회원가입
  Future<UserModel?> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        return UserModel.fromFirebaseUser(userCredential.user!);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw '회원가입 중 오류가 발생했습니다: $e';
    }
  }

  // 이메일/비밀번호 로그인
  Future<UserModel?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        return UserModel.fromFirebaseUser(userCredential.user!);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw '로그인 중 오류가 발생했습니다: $e';
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw '로그아웃 중 오류가 발생했습니다: $e';
    }
  }

  // 비밀번호 재설정 이메일 전송
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw '비밀번호 재설정 이메일 전송 중 오류가 발생했습니다: $e';
    }
  }

  // Firebase Auth 예외 처리
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return '비밀번호가 너무 약합니다.';
      case 'email-already-in-use':
        return '이미 사용 중인 이메일입니다.';
      case 'invalid-email':
        return '유효하지 않은 이메일 주소입니다.';
      case 'user-not-found':
        return '해당 이메일로 등록된 사용자가 없습니다.';
      case 'wrong-password':
        return '비밀번호가 일치하지 않습니다.';
      case 'user-disabled':
        return '비활성화된 사용자입니다.';
      case 'too-many-requests':
        return '너무 많은 요청이 발생했습니다. 잠시 후 다시 시도해주세요.';
      case 'operation-not-allowed':
        return '이메일/비밀번호 로그인이 활성화되지 않았습니다.';
      default:
        return '인증 오류가 발생했습니다: ${e.message}';
    }
  }
}
