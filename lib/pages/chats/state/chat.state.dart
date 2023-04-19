import 'package:portfolio/models/models.dart';
import 'package:portfolio/pages/pages.dart';
import 'package:portfolio/services/services.dart';
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

@riverpod
class GetMessagesByChatId extends _$GetMessagesByChatId {
  @override
  Stream<List<ChatMessage>> build(String chatId) {
    return ref.read(chatServiceProvider).watchMessages(chatId: chatId);
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
      return ref.read(chatServiceProvider).sendMessage(
            chatId: chatId,
            uid: user!.uid,
            message: message,
          );
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
