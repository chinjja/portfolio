import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:portfolio/providers/providers/firebase_messaging_provider.dart';

final fcmServiceProvider = Provider((ref) => FcmService(ref));

final fcmServerKeyProvider = FutureProvider((ref) async {
  String jsonString =
      await rootBundle.loadString('assets/google-services.json');
  Map<String, dynamic> jsonMap = json.decode(jsonString);
  String fcmServiceKey = jsonMap['fcm_server_key'];
  return fcmServiceKey;
});

class FcmService {
  final Ref ref;

  FcmService(this.ref);

  Future<bool> send({
    required List<String> userTokens,
    required String title,
    required String body,
    required String chatId,
  }) async {
    try {
      final serverKey = await ref.read(fcmServerKeyProvider.future);
      final response = await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=$serverKey'
          },
          body: jsonEncode({
            'notification': {
              'title': title,
              'body': body,
              'click_action': 'https://portfolio-bce4c.web.app/chats/$chatId',
            },
            'data': {'chatId': chatId},
            'content_available': true,
            'priority': 'high',
            // 상대방 토큰 값, to -> 단일, registration_ids -> 여러명
            // 'to': userToken
            'registration_ids': userTokens,
          }));
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      print('error $e');
      return false;
    }
  }

  Future<String?> getToken() async {
    final firebaseMessaging = ref.read(firebaseMessagingProvider);
    return await firebaseMessaging.getToken(
        vapidKey:
            'BCBTAiZ53Yb34xaAgX_zwprwf5qS4R1UdFdDZr4YFQ-cgOJHMHOrUkLqZ7hLqjQK3vI2F683bKjSTw551GI3EDM');
  }

  Stream<String> get onTokenRefresh {
    final firebaseMessaging = ref.read(firebaseMessagingProvider);
    return firebaseMessaging.onTokenRefresh;
  }
}
