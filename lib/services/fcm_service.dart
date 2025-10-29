import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FCMService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // FCM 초기화 및 권한 요청
  Future<void> initialize() async {
    try {
      // 알림 권한 요청
      await requestPermission();

      // 알림 채널 설정 (Android)
      await _setupNotificationChannel();

      // 초기 메시지 확인 (앱이 종료된 상태에서 알림 클릭으로 실행된 경우)
      RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        _handleMessage(initialMessage);
      }

      // Foreground 메시지 리스너
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // 백그라운드에서 알림 클릭 시 처리
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

      // FCM 토큰 확인
      final token = await getToken();
      if (token != null) {
        debugPrint('✅ FCM 토큰: $token');
      }

      debugPrint('✅ FCM 초기화 완료');
    } catch (e) {
      debugPrint('❌ FCM 초기화 실패: $e');
    }
  }

  // 알림 권한 요청
  Future<bool> requestPermission() async {
    try {
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('✅ 알림 권한 승인됨');
        return true;
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        debugPrint('⚠️ 임시 알림 권한 승인됨');
        return true;
      } else {
        debugPrint('❌ 알림 권한 거부됨');
        return false;
      }
    } catch (e) {
      debugPrint('❌ 알림 권한 요청 실패: $e');
      return false;
    }
  }

  // FCM 토큰 가져오기
  Future<String?> getToken() async {
    try {
      String? token = await _messaging.getToken();
      if (token != null) {
        debugPrint('📱 FCM 토큰: $token');
        // TODO: 서버에 토큰 저장
      }
      return token;
    } catch (e) {
      debugPrint('❌ FCM 토큰 가져오기 실패: $e');
      return null;
    }
  }

  // 토큰 갱신 리스너
  Stream<String> get onTokenRefresh {
    return _messaging.onTokenRefresh;
  }

  // Foreground 메시지 스트림
  Stream<RemoteMessage> get onMessage {
    return FirebaseMessaging.onMessage;
  }

  // 알림 클릭 처리 설정
  Future<void> setupInteractedMessage() async {
    // 앱이 종료된 상태에서 알림 클릭으로 실행된 경우
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // 백그라운드에서 알림 클릭 시
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  // Foreground 메시지 처리
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('🔔 Foreground 메시지 수신');
    debugPrint('제목: ${message.notification?.title}');
    debugPrint('내용: ${message.notification?.body}');
    debugPrint('데이터: ${message.data}');

    // TODO: 로컬 알림 표시 또는 UI 업데이트
  }

  // 알림 클릭 시 처리
  void _handleMessage(RemoteMessage message) {
    debugPrint('📬 알림 클릭됨');
    debugPrint('제목: ${message.notification?.title}');
    debugPrint('내용: ${message.notification?.body}');
    debugPrint('데이터: ${message.data}');

    // TODO: 특정 화면으로 이동 처리
    // 예: Navigator.pushNamed(context, '/detail', arguments: message.data);
  }

  // Android 알림 채널 설정
  Future<void> _setupNotificationChannel() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      // Android 알림 채널 생성은 flutter_local_notifications 패키지가 필요합니다.
      // 현재는 FirebaseMessaging 플러그인이 자동으로 처리하도록 둡니다.
      debugPrint('📱 Android 알림 채널 설정 (자동)');
    }
  }

  // FCM 토큰 삭제 (로그아웃 시 사용)
  Future<void> deleteToken() async {
    try {
      await _messaging.deleteToken();
      debugPrint('✅ FCM 토큰 삭제 완료');
    } catch (e) {
      debugPrint('❌ FCM 토큰 삭제 실패: $e');
    }
  }

  // 특정 토픽 구독
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      debugPrint('✅ 토픽 구독 완료: $topic');
    } catch (e) {
      debugPrint('❌ 토픽 구독 실패: $e');
    }
  }

  // 특정 토픽 구독 해제
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      debugPrint('✅ 토픽 구독 해제 완료: $topic');
    } catch (e) {
      debugPrint('❌ 토픽 구독 해제 실패: $e');
    }
  }
}
