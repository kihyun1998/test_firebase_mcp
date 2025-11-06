import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/notification_model.dart';
import 'providers/auth_service_provider.dart';
import 'providers/fcm_provider.dart';
import 'providers/notifications_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

// 백그라운드 메시지 핸들러 (최상위 함수여야 함)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('🔔 백그라운드 메시지 수신: ${message.messageId}');
  debugPrint('제목: ${message.notification?.title}');
  debugPrint('내용: ${message.notification?.body}');
  debugPrint('데이터: ${message.data}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // 백그라운드 메시지 핸들러 등록
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Naver Map 초기화
  // TODO: 'YOUR_CLIENT_ID_HERE'를 Naver Cloud Platform에서 발급받은 Client ID로 교체하세요
  await FlutterNaverMap().init(
    clientId: 'tn4hbzrm1m',
    onAuthFailed: (ex) {
      debugPrint('네이버 지도 인증 실패: $ex');
    },
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    // 로그인 상태 변경 시 FCM 초기화
    ref.listen(authStateChangesProvider, (previous, next) {
      next.whenData((user) {
        if (user != null) {
          // 로그인 성공 시 FCM 초기화
          ref.read(fcmControllerProvider.notifier).initializeFCM();
        }
      });
    });

    // Foreground 메시지 수신 시 알림 목록에 추가
    ref.listen(foregroundMessagesProvider, (previous, next) {
      next.whenData((message) {
        debugPrint('🔔 Foreground 메시지 수신: ${message.notification?.title}');
        final notification = NotificationModel.fromRemoteMessage(message);
        ref.read(notificationsProvider.notifier).addNotification(notification);

        // 스낵바로 알림 표시
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message.notification?.title ?? "알림"),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: '보기',
              onPressed: () {
                // 알림 페이지로 이동
              },
            ),
          ),
        );
      });
    });

    return authState.when(
      data: (user) {
        if (user != null) {
          return const HomeScreen();
        }
        return const LoginScreen();
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('Error: $error'))),
    );
  }
}
