import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/app/app.dart';
import 'package:portfolio/pages/home/view/home_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home.state.g.dart';

@Riverpod(keepAlive: true)
class ListenNotification extends _$ListenNotification {
  @override
  Stream<RemoteMessage> build() {
    return FirebaseMessaging.onMessage
        .where(
          (event) {
            final chatId = event.data['chatId'];
            if (chatId == null) return false;
            final p = onChatIdProvider;
            if (!ref.exists(p)) return true;
            final currentChatId = ref.read(p);
            return currentChatId != chatId;
          },
        )
        .where((event) => event.notification != null)
        .cast<RemoteMessage>();
  }

  void showNotification(BuildContext context, RemoteMessage message) {
    showDialog(
      context: context,
      barrierColor: null,
      barrierDismissible: false,
      builder: (context) {
        final notification = message.notification;
        return NotificationDialog(
          chatId: message.data['chatId']!,
          title: notification?.title ?? '',
          body: notification?.body ?? '',
        );
      },
    );
  }
}

@riverpod
class OnChatId extends _$OnChatId {
  @override
  String build() {
    return '';
  }

  void setChatId(String chatId) {
    state = chatId;
  }
}
