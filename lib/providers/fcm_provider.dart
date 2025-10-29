import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../services/fcm_service.dart';

part 'fcm_provider.g.dart';

// FCMService Provider
@Riverpod(dependencies: [])
FCMService fcmService(Ref ref) {
  return FCMService();
}

// FCM 토큰 Provider
@Riverpod(dependencies: [fcmService])
Future<String?> fcmToken(Ref ref) async {
  final service = ref.watch(fcmServiceProvider);
  return await service.getToken();
}

// 토큰 갱신 스트림 Provider
@Riverpod(dependencies: [fcmService])
Stream<String> tokenRefresh(Ref ref) {
  final service = ref.watch(fcmServiceProvider);
  return service.onTokenRefresh;
}

// Foreground 메시지 스트림 Provider
@Riverpod(dependencies: [fcmService])
Stream<RemoteMessage> foregroundMessages(Ref ref) {
  final service = ref.watch(fcmServiceProvider);
  return service.onMessage;
}

// FCM 컨트롤러 (초기화 및 권한 요청)
@Riverpod(dependencies: [fcmService])
class FcmController extends _$FcmController {
  @override
  FutureOr<void> build() {
    // 초기 상태는 아무것도 하지 않음
  }

  // FCM 초기화
  Future<void> initializeFCM() async {
    state = await AsyncValue.guard(() async {
      final service = ref.read(fcmServiceProvider);
      await service.initialize();
    });
  }

  // 알림 권한 요청
  Future<bool> requestPermission() async {
    try {
      final service = ref.read(fcmServiceProvider);
      final result = await service.requestPermission();
      state = const AsyncData(null);
      return result;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }

  // 토픽 구독
  Future<void> subscribeToTopic(String topic) async {
    state = await AsyncValue.guard(() async {
      final service = ref.read(fcmServiceProvider);
      await service.subscribeToTopic(topic);
    });
  }

  // 토픽 구독 해제
  Future<void> unsubscribeFromTopic(String topic) async {
    state = await AsyncValue.guard(() async {
      final service = ref.read(fcmServiceProvider);
      await service.unsubscribeFromTopic(topic);
    });
  }

  // FCM 토큰 삭제 (로그아웃 시)
  Future<void> deleteToken() async {
    state = await AsyncValue.guard(() async {
      final service = ref.read(fcmServiceProvider);
      await service.deleteToken();
    });
  }
}
