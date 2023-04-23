import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/models/models.dart';
import 'package:portfolio/pages/pages.dart';
import 'package:portfolio/services/services.dart';
import 'package:portfolio/services/services/fcm_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuple/tuple.dart';

part 'chat.state.g.dart';

@riverpod
class GetChat extends _$GetChat {
  @override
  Stream<Chat?> build(String id) {
    return ref.read(chatServiceProvider).watchById(id);
  }
}

@riverpod
class GetChats extends _$GetChats {
  @override
  Stream<List<Chat>> build() {
    return ref.read(chatServiceProvider).chats;
  }
}

@riverpod
class GetChatsByUid extends _$GetChatsByUid {
  @override
  Stream<List<Chat>> build(String uid) {
    return ref.read(chatServiceProvider).watchChatsByUid(uid: uid);
  }
}

@riverpod
class CreateDirectChat extends _$CreateDirectChat {
  @override
  FutureOr<Chat?> build(String uid) {
    return null;
  }

  Future<void> create() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final to = await ref.read(getOwnerUidProvider.future);
      return await ref
          .read(chatServiceProvider)
          .createDirectChat(uid: uid, to: to);
    });
  }
}

final isEndReachedProvider = StateProvider.autoDispose((ref) => false);

@riverpod
class GetMessagesByChatId extends _$GetMessagesByChatId {
  @override
  Future<ChatMessageList> build(String chatId) async {
    ref.listen(getLatestMessagesByChatIdProvider(chatId), (previous, next) {
      state.whenData((value) {
        state = AsyncValue.data(value.appendToFront(next.requireValue!));
      });
    });
    final messages = await ref
        .read(chatServiceProvider)
        .getRawMessages(chatId: chatId, limit: 25);
    return ChatMessageList(
      messages: messages.map((e) => ChatMessage.fromJson(e.data()!)).toList(),
      isEndReached: messages.length < 25,
      cursor: messages.isEmpty ? null : messages.last,
    );
  }

  Future<void> fetchMore() async {
    final value = state.valueOrNull;
    if (value == null || value.isEndReached) return;

    final messages = await ref
        .read(chatServiceProvider)
        .getRawMessages(cursor: value.cursor, chatId: chatId, limit: 25);

    state = AsyncValue.data(
      value.append(
        messages.map((e) => ChatMessage.fromJson(e.data()!)).toList(),
        isEndReached: messages.length < 25,
        cursor: messages.isEmpty ? value.cursor : messages.last,
      ),
    );
  }
}

@riverpod
class GetLatestMessagesByChatId extends _$GetLatestMessagesByChatId {
  @override
  Stream<ChatMessage?> build(String chatId) {
    return ref.read(chatServiceProvider).watchLatestMessage(chatId: chatId);
  }
}

@riverpod
class SendMessage extends _$SendMessage {
  @override
  FutureOr<ChatMessage?> build(String chatId) {
    return null;
  }

  Future<void> send(String message) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = ref.read(getCurrentUserProvider);
      final res = ref.read(chatServiceProvider).sendMessage(
            chatId: chatId,
            uid: user!.uid,
            message: message,
          );
      final users = await ref.read(getChatUsersByChatIdProvider(chatId).future);
      final tokens = users
          .map((e) => e.fcmToken)
          .where((e) => e != null)
          .cast<String>()
          .toList();
      if (tokens.isNotEmpty) {
        ref.read(fcmServiceProvider).send(
              userTokens: tokens,
              title: '${user.displayName}님이 메시지를 보냈습니다.',
              body: message,
              chatId: chatId,
            );
      }
      return res;
    });
  }
}

@Riverpod(keepAlive: true)
class MemberByUid extends _$MemberByUid {
  @override
  FutureOr<Member?> build(String uid) async {
    return await ref.read(userServiceProvider).getMemberByUid(uid);
  }
}

@riverpod
class GetChatUsersByChatId extends _$GetChatUsersByChatId {
  @override
  Stream<List<ChatUser>> build(String chatId) {
    return ref.read(chatServiceProvider).watchChatUsersByChatId(chatId: chatId);
  }
}

@riverpod
class GetChatUserMapByChatId extends _$GetChatUserMapByChatId {
  @override
  Future<Map<String, ChatUser>> build(String chatId) async {
    final list = await ref.watch(getChatUsersByChatIdProvider(chatId).future);
    return list.asMap().map((key, value) => MapEntry(value.uid, value));
  }
}

@riverpod
class GetChatTitle extends _$GetChatTitle {
  @override
  FutureOr<String> build(String chatId) async {
    final user = ref.watch(getCurrentUserProvider);
    final chatUsers =
        ref.watch(getChatUsersByChatIdProvider(chatId)).valueOrNull ?? [];
    final others = chatUsers.where((e) => e.uid != user?.uid).toList();
    return others.map((e) => e.displayName ?? '이름없음').join(', ');
  }
}

@riverpod
class GetChatAvatarUrl extends _$GetChatAvatarUrl {
  @override
  FutureOr<String?> build(String chatId) async {
    final user = ref.watch(getCurrentUserProvider);
    final chatUsers =
        ref.watch(getChatUsersByChatIdProvider(chatId)).valueOrNull ?? [];
    final others = chatUsers.where((e) => e.uid != user?.uid).toList();
    final list = others.take(1).map((e) => e.photoUrl);
    if (list.isEmpty) return null;
    return list.first;
  }
}
