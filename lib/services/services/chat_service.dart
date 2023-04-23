import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/models/models.dart';
import 'package:portfolio/providers/providers.dart';
import 'package:portfolio/services/services.dart';
import 'package:rxdart/rxdart.dart';

final chatServiceProvider = Provider((ref) => ChatService(ref));

class ChatService {
  static const _chats = 'chats';
  static const _chatUsers = 'chat-users';
  final Ref ref;

  ChatService(this.ref);

  Stream<List<Chat>> get chats {
    final firestore = ref.read(firebaseFirestoreProvider);
    return firestore
        .collection(_chats)
        .snapshots()
        .map((e) => e.docs.map((e) => Chat.fromJson(e.data())).toList());
  }

  Stream<Chat?> watchById(String id) {
    final firestore = ref.read(firebaseFirestoreProvider);
    return firestore
        .collection(_chats)
        .doc(id)
        .snapshots()
        .map((e) => e.exists ? Chat.fromJson(e.data()!) : null);
  }

  Future<Chat?> getById(String id) async {
    final firestore = ref.read(firebaseFirestoreProvider);
    final res = await firestore.collection(_chats).doc(id).get();
    if (!res.exists) return null;
    return Chat.fromJson(res.data()!);
  }

  Stream<List<Chat>> watchChatsByUid({
    required String uid,
  }) {
    final firestore = ref.read(firebaseFirestoreProvider);
    return firestore
        .collection(_chatUsers)
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((e) => e.docs)
        .flatMap((e) => Stream.value(e).map((e) => e
            .map((e) => e.data())
            .map((json) => Chat(id: json['chatId']))
            .toSet()
            .toList()));
  }

  Stream<List<ChatUser>> watchChatUsersByChatId({
    required String chatId,
  }) {
    final firestore = ref.read(firebaseFirestoreProvider);

    return firestore
        .collection(_chatUsers)
        .where('chatId', isEqualTo: chatId)
        .snapshots()
        .map((e) => e.docs)
        .flatMap((e) => Stream.value(e).map((e) => e
            .map((e) => e.data())
            .map((json) => ChatUser.fromJson(json))
            .toList()));
  }

  Future<List<ChatUser>> getChatUsersByUid({
    required String uid,
  }) async {
    final firestore = ref.read(firebaseFirestoreProvider);

    final res = await firestore
        .collection(_chatUsers)
        .where('uid', isEqualTo: uid)
        .get();
    return res.docs.map((e) => ChatUser.fromJson(e.data())).toList();
  }

  Future<Chat?> getDirectChat({
    required String uid,
    required String to,
  }) async {
    final firestore = ref.read(firebaseFirestoreProvider);
    final res = await firestore
        .collection(_chatUsers)
        .where('uid', isEqualTo: uid)
        .where('type', isEqualTo: to)
        .get();
    if (res.size == 0) return null;
    final chatId = res.docs.first.data()['chatId'];
    return Chat(id: chatId);
  }

  Future<Chat> createDirectChat({
    required String uid,
    required String to,
  }) async {
    final firestore = ref.read(firebaseFirestoreProvider);
    final chat1 = await getDirectChat(uid: uid, to: to);
    if (chat1 != null) {
      return chat1;
    }
    final uuid = ref.read(uuidProvider);
    final chat = Chat(id: uuid.v4(), name: '');
    final member1 = await ref.read(userServiceProvider).getMemberByUid(uid);
    final user1 = ChatUser(
      id: uuid.v4(),
      uid: uid,
      type: to,
      chatId: chat.id,
      photoUrl: member1!.photoUrl,
      displayName: member1.displayName,
      fcmToken: member1.fcmToken,
    );
    final member2 = await ref.read(userServiceProvider).getMemberByUid(to);
    final user2 = ChatUser(
      id: uuid.v4(),
      uid: to,
      type: uid,
      chatId: chat.id,
      photoUrl: member2!.photoUrl,
      displayName: member2.displayName,
      fcmToken: member2.fcmToken,
    );
    firestore.runTransaction((t) async {
      t.set(firestore.collection(_chats).doc(chat.id), chat.toJson());
      t.set(firestore.collection(_chatUsers).doc(user1.id), user1.toJson());
      t.set(firestore.collection(_chatUsers).doc(user2.id), user2.toJson());
    });
    return chat;
  }

  Future<ChatMessage> sendMessage({
    required String chatId,
    required String uid,
    required String message,
  }) async {
    final firestore = ref.read(firebaseFirestoreProvider);
    final id = ref.read(uuidProvider).v4();
    final chatMessage = ChatMessage(
      id: id,
      uid: uid,
      chatId: chatId,
      message: message,
      date: DateTime.now(),
    );
    await firestore
        .collection(_chats)
        .doc(chatId)
        .collection('messages')
        .doc(id)
        .set(chatMessage.toJson());
    return chatMessage;
  }

  Stream<List<ChatMessage>> watchMessages({
    required String chatId,
    required int limit,
  }) {
    final firestore = ref.read(firebaseFirestoreProvider);
    return firestore
        .collection(_chats)
        .doc(chatId)
        .collection('messages')
        .orderBy('date', descending: true)
        .limit(limit)
        .snapshots()
        .map((e) => e.docs.map((e) => ChatMessage.fromJson(e.data())).toList());
  }

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getRawMessages({
    DocumentSnapshot<Object?>? cursor,
    required String chatId,
    required int limit,
  }) async {
    final firestore = ref.read(firebaseFirestoreProvider);
    var builder = firestore
        .collection(_chats)
        .doc(chatId)
        .collection('messages')
        .orderBy('date', descending: true);
    if (cursor != null) {
      builder = builder.startAfterDocument(cursor);
    }

    final res = await builder.limit(limit).get();
    return res.docs;
  }

  Stream<ChatMessage?> watchLatestMessage({
    required String chatId,
  }) {
    final firestore = ref.read(firebaseFirestoreProvider);
    return firestore
        .collection(_chats)
        .doc(chatId)
        .collection('messages')
        .orderBy('date', descending: true)
        .limit(1)
        .snapshots()
        .map((e) => e.docs)
        .map((e) => e.isEmpty ? null : ChatMessage.fromJson(e.first.data()));
  }

  Future<void> updateFcmToken(
    User user, {
    String? fcmToken,
  }) async {
    final firestore = ref.read(firebaseFirestoreProvider);
    final chatUsers = await getChatUsersByUid(uid: user.uid);
    await firestore.runTransaction((transaction) async {
      for (final chatUser in chatUsers) {
        final doc = firestore.collection(_chatUsers).doc(chatUser.id);
        transaction.update(doc, {
          'fcmToken': fcmToken,
        });
      }
    });
  }
}
