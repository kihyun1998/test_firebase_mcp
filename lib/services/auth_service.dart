import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  // Google Access Token 저장
  String? _accessToken;

  // Google Sign-In Account 저장 (v7.0+: 토큰 갱신용)
  GoogleSignInAccount? _googleSignInAccount;

  // Google Sign-In 초기화 (v7.0+ 필수)
  // 다른 메서드 호출 전에 정확히 한 번 호출되어야 함
  Future<void> initialize() async {
    await _googleSignIn.initialize();
  }

  // 현재 사용자 스트림
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 현재 사용자
  User? get currentUser => _auth.currentUser;

  // 현재 Google Access Token
  String? get accessToken => _accessToken;

  // 현재 사용자 모델
  UserModel? get currentUserModel {
    final user = currentUser;
    if (user == null) return null;
    return UserModel.fromFirebaseUser(user);
  }

  // ID Token 가져오기
  Future<String?> getIDToken({bool forceRefresh = false}) async {
    try {
      final user = currentUser;
      if (user == null) return null;

      // forceRefresh가 true면 갱신, false면 캐시된 토큰 반환
      final idToken = await user.getIdToken(forceRefresh);
      return idToken;
    } catch (e) {
      throw 'ID Token을 가져올 수 없습니다: $e';
    }
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

  // Google 로그인
  Future<UserModel?> signInWithGoogle() async {
    try {
      print('🔵 Google 로그인 시작...');

      // Google 로그인 시작 (v7.0+: signIn → authenticate)
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      print('🔵 GoogleSignInAccount: ${googleUser.email}');

      // GoogleSignInAccount 저장 (토큰 갱신용)
      _googleSignInAccount = googleUser;

      // Google 인증 정보 가져오기
      print('🔵 Google 인증 정보 가져오는 중...');
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      print('🔵 IdToken: ${googleAuth.idToken != null ? "존재함" : "null"}');

      // v7.0+: accessToken은 authorization을 통해 획득
      print('🔵 AccessToken 요청 중...');
      final scopes = <String>['email'];
      var authorization = await googleUser.authorizationClient
          .authorizationForScopes(scopes);

      // 권한이 없으면 사용자에게 요청
      if (authorization == null) {
        print('🔵 사용자에게 권한 요청 중...');
        authorization = await googleUser.authorizationClient.authorizeScopes(
          scopes,
        );
      }

      print(
        '🔵 AccessToken: ${authorization.accessToken != null ? "존재함" : "null"}',
      );

      // AccessToken 저장
      _accessToken = authorization.accessToken;

      // Firebase 인증 자격 증명 생성
      print('🔵 Firebase 인증 자격 증명 생성 중...');
      final credential = GoogleAuthProvider.credential(
        accessToken: authorization.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase에 로그인
      print('🔵 Firebase 로그인 시도 중...');
      final userCredential = await _auth.signInWithCredential(credential);
      print('✅ Firebase 로그인 성공: ${userCredential.user?.email}');

      if (userCredential.user != null) {
        return UserModel.fromFirebaseUser(userCredential.user!);
      }
      return null;
    } on GoogleSignInException catch (e) {
      // v7.0+: GoogleSignInException 처리
      print('❌ GoogleSignInException: ${e.code}');
      print('❌ Description: ${e.description}');
      if (e.code == GoogleSignInExceptionCode.canceled) {
        print('⚠️ 사용자가 Google 로그인을 취소했습니다');
        throw 'Google 로그인이 취소되었습니다.';
      }
      throw 'Google 로그인 오류: ${e.description}';
    } on FirebaseAuthException catch (e) {
      print('❌ FirebaseAuthException: ${e.code}');
      print('❌ Message: ${e.message}');
      print('❌ StackTrace: ${e.stackTrace}');
      throw _handleAuthException(e);
    } catch (e, stackTrace) {
      print('❌ Google 로그인 에러: $e');
      print('❌ StackTrace: $stackTrace');
      throw 'Google 로그인 중 오류가 발생했습니다: $e';
    }
  }

  // Google Access Token 갱신
  Future<String?> refreshAccessToken() async {
    try {
      if (_googleSignInAccount == null) {
        throw 'Google 계정에 로그인되어 있지 않습니다.';
      }

      print('🔵 Access Token 갱신 중...');
      final scopes = <String>['email'];

      final authorization = await _googleSignInAccount!.authorizationClient
          .authorizationForScopes(scopes);

      if (authorization == null) {
        print('🔵 권한이 없어서 사용자에게 재요청...');
        final newAuthorization = await _googleSignInAccount!.authorizationClient
            .authorizeScopes(scopes);
        _accessToken = newAuthorization.accessToken;
        print('✅ Access Token 갱신 완료: ${_accessToken != null ? "존재함" : "null"}');
        return _accessToken;
      }

      _accessToken = authorization.accessToken;
      print('✅ Access Token 갱신 완료: ${_accessToken != null ? "존재함" : "null"}');
      return _accessToken;
    } on GoogleSignInException catch (e) {
      print('❌ GoogleSignInException: ${e.code}');
      print('❌ Description: ${e.description}');
      throw 'Access Token 갱신 오류: ${e.description}';
    } catch (e) {
      print('❌ Access Token 갱신 에러: $e');
      throw 'Access Token 갱신 중 오류가 발생했습니다: $e';
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    try {
      _accessToken = null; // Access Token 초기화
      _googleSignInAccount = null; // Google Account 초기화
      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
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
