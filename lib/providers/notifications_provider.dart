import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/notification_model.dart';

part 'notifications_provider.g.dart';

// 알림 목록 Notifier
@Riverpod(dependencies: [])
class Notifications extends _$Notifications {
  @override
  List<NotificationModel> build() {
    return [];
  }

  // 새 알림 추가
  void addNotification(NotificationModel notification) {
    state = [notification, ...state];
  }

  // 알림 읽음 처리
  void markAsRead(String id) {
    state = [
      for (final notification in state)
        if (notification.id == id)
          notification.copyWith(isRead: true)
        else
          notification,
    ];
  }

  // 모든 알림 읽음 처리
  void markAllAsRead() {
    state = [
      for (final notification in state) notification.copyWith(isRead: true),
    ];
  }

  // 특정 알림 삭제
  void deleteNotification(String id) {
    state = state.where((notification) => notification.id != id).toList();
  }

  // 모든 알림 삭제
  void clearAll() {
    state = [];
  }

  // 읽지 않은 알림 개수
  int get unreadCount {
    return state.where((notification) => !notification.isRead).length;
  }
}

// 읽지 않은 알림 개수 Provider
@Riverpod(dependencies: [Notifications])
int unreadNotificationsCount(Ref ref) {
  final notifications = ref.watch(notificationsProvider);
  return notifications.where((notification) => !notification.isRead).length;
}
