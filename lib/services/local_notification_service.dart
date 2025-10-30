import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  // 싱글톤 패턴
  static final LocalNotificationService _instance =
      LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  // 초기화
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Android 설정
      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS 설정
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      // 초기화 설정
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // 초기화
      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Android 알림 채널 생성
      await _createNotificationChannel();

      _initialized = true;
      debugPrint('✅ LocalNotificationService 초기화 완료');
    } catch (e) {
      debugPrint('❌ LocalNotificationService 초기화 실패: $e');
    }
  }

  // Android 알림 채널 생성
  Future<void> _createNotificationChannel() async {
    if (defaultTargetPlatform != TargetPlatform.android) return;

    const channel = AndroidNotificationChannel(
      'high_importance_channel', // id (AndroidManifest.xml과 일치)
      '일반 알림', // name
      description: '일반적인 푸시 알림',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    debugPrint('✅ Android 알림 채널 생성 완료');
  }

  // 알림 표시
  Future<void> showNotification({
    required String title,
    required String body,
    String? imageUrl,
    Map<String, dynamic>? data,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    try {
      // 알림 ID 생성 (타임스탬프 사용)
      final notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // Android 알림 상세 설정
      const androidDetails = AndroidNotificationDetails(
        'high_importance_channel', // channelId
        '일반 알림', // channelName
        channelDescription: '일반적인 푸시 알림',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        icon: '@mipmap/ic_launcher',
        styleInformation: BigTextStyleInformation(''),
      );

      // iOS 알림 상세 설정
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      // 통합 알림 상세 설정
      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // 알림 표시
      await _notifications.show(
        notificationId,
        title,
        body,
        notificationDetails,
        payload: data?.toString(),
      );

      debugPrint('🔔 로컬 알림 표시: $title - $body');
    } catch (e) {
      debugPrint('❌ 로컬 알림 표시 실패: $e');
    }
  }

  // 알림 클릭 처리
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('📬 알림 클릭됨: ${response.payload}');
    // TODO: 알림 클릭 시 특정 화면으로 이동 처리
    // Navigator를 사용하려면 GlobalKey<NavigatorState> 필요
  }

  // 모든 알림 취소
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
    debugPrint('🗑️ 모든 로컬 알림 취소');
  }

  // 특정 알림 취소
  Future<void> cancel(int id) async {
    await _notifications.cancel(id);
    debugPrint('🗑️ 로컬 알림 취소: $id');
  }
}
