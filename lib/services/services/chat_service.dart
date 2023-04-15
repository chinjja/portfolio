import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/models/models.dart';
import 'package:portfolio/providers/providers.dart';

final chatServiceProvider = Provider((ref) => ChatService(ref));

class ChatService {
  static const prefix = 'chats';
  final Ref ref;

  ChatService(this.ref);

  Stream<List<Chat>> get chats {
    final firestore = ref.read(firebaseFirestoreProvider);
    return firestore
        .collection(prefix)
        .snapshots()
        .map((e) => e.docs.map((e) => Chat.fromJson(e.data())).toList());
  }

  Stream<Chat?> get(String id) {
    final firestore = ref.read(firebaseFirestoreProvider);
    return firestore
        .collection(prefix)
        .doc(id)
        .snapshots()
        .map((e) => e.exists ? Chat.fromJson(e.data()!) : null);
  }

  Future<Chat> chat({
    required String uid,
    required String to,
  }) async {
    final firestore = ref.read(firebaseFirestoreProvider);
    return await firestore.runTransaction((transaction) async {
      final doc = firestore.collection(prefix).doc(makeChatId(uid, to));
      final res = await transaction.get(doc);
      if (res.exists) {
        return Chat.fromJson(res.data()!);
      }
      final chat = Chat(id: doc.id, name: '');
      transaction.set(doc, chat.toJson());
      return chat;
    });
  }

  Future<void> send({
    required String uid,
    required String to,
    required String message,
  }) async {
    final firestore = ref.read(firebaseFirestoreProvider);
    final chat = await this.chat(uid: uid, to: to);
    final id = ref.read(uuidProvider).v4();
    final chatMessage = ChatMessage(
      id: id,
      uid: uid,
      chatId: chat.id,
      message: message,
      date: DateTime.now(),
    );
    await firestore
        .collection(prefix)
        .doc(chat.id)
        .collection('messages')
        .doc(id)
        .set(chatMessage.toJson());
  }

  Stream<List<ChatMessage>> messages({
    required String chatId,
  }) {
    final firestore = ref.read(firebaseFirestoreProvider);
    return firestore
        .collection(prefix)
        .doc(chatId)
        .collection('messages')
        .orderBy('date', descending: true)
        .snapshots()
        .map((e) => e.docs.map((e) => ChatMessage.fromJson(e.data())).toList());
  }

  String makeChatId(String uid1, String uid2) {
    if (uid1.compareTo(uid2) > 0) return uid2 + uid1;
    return uid1 + uid2;
  }
}
