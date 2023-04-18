import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/models/models.dart';
import 'package:portfolio/providers/providers.dart';
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

  Stream<List<String>> watchChatIdsByUid({
    required String uid,
  }) {
    final firestore = ref.read(firebaseFirestoreProvider);
    return firestore
        .collection(_chatUsers)
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((e) => e.docs)
        .flatMap((e) => Stream.fromIterable(e)
            .map((e) => e.data())
            .map((e) => e['chatId']));
  }

  Future<String?> getChatIdByUid({
    required String uid,
    required String type,
  }) async {
    final firestore = ref.read(firebaseFirestoreProvider);
    final res = await firestore
        .collection(_chatUsers)
        .where('uid', isEqualTo: uid)
        .where('type', isEqualTo: type)
        .get();
    if (res.size == 0) return null;
    return res.docs.first.data()['chatId'];
  }

  Future<Chat> createDirectChat({
    required String uid,
    required String to,
  }) async {
    final firestore = ref.read(firebaseFirestoreProvider);
    final chatId = await getChatIdByUid(uid: uid, type: to);
    if (chatId != null) {
      final res = await getById(chatId);
      if (res != null) return res;
    }
    final uuid = ref.read(uuidProvider);
    final chat = Chat(id: uuid.v4(), name: '');
    final user1 = ChatUser(
      id: uuid.v4(),
      uid: uid,
      type: to,
      chatId: chat.id,
    );
    final user2 = ChatUser(
      id: uuid.v4(),
      uid: to,
      type: uid,
      chatId: chat.id,
    );
    firestore.runTransaction((t) async {
      t.set(firestore.collection(_chats).doc(chat.id), chat.toJson());
      t.set(firestore.collection(_chatUsers).doc(user1.id), user1.toJson());
      t.set(firestore.collection(_chatUsers).doc(user2.id), user2.toJson());
    });
    return chat;
  }

  Future<void> send({
    required Chat chat,
    required String uid,
    required String message,
  }) async {
    final firestore = ref.read(firebaseFirestoreProvider);
    final id = ref.read(uuidProvider).v4();
    final chatMessage = ChatMessage(
      id: id,
      uid: uid,
      chatId: chat.id,
      message: message,
      date: DateTime.now(),
    );
    await firestore
        .collection(_chats)
        .doc(chat.id)
        .collection('messages')
        .doc(id)
        .set(chatMessage.toJson());
  }

  Stream<List<ChatMessage>> watchMessages({
    required String chatId,
  }) {
    final firestore = ref.read(firebaseFirestoreProvider);
    return firestore
        .collection(_chats)
        .doc(chatId)
        .collection('messages')
        .orderBy('date', descending: true)
        .snapshots()
        .map((e) => e.docs.map((e) => ChatMessage.fromJson(e.data())).toList());
  }
}
