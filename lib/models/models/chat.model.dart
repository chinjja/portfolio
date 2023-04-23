import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:portfolio/models/models/common.dart';

part 'chat.model.freezed.dart';
part 'chat.model.g.dart';

@freezed
class Chat with _$Chat {
  const factory Chat({
    @Default('') String id,
    @Default('') String name,
  }) = _Chat;

  factory Chat.fromJson(Json json) => _$ChatFromJson(json);
}

@freezed
class ChatUser with _$ChatUser {
  const factory ChatUser({
    @Default('') String id,
    @Default('') String uid,
    @Default('') String type,
    required String chatId,
    String? photoUrl,
    String? displayName,
    String? fcmToken,
  }) = _ChatUser;

  factory ChatUser.fromJson(Json json) => _$ChatUserFromJson(json);
}

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    @Default('') String id,
    @Default('') String uid,
    @Default('') String chatId,
    @Default('') String message,
    DateTime? date,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Json json) => _$ChatMessageFromJson(json);
}

@freezed
class ChatMessageList with _$ChatMessageList {
  const factory ChatMessageList({
    @Default(false) bool isEndReached,
    @Default([]) List<ChatMessage> messages,
    DocumentSnapshot? cursor,
  }) = _ChatMessageList;
}

extension ChatMessageListX on ChatMessageList {
  ChatMessageList append(
    List<ChatMessage> messages, {
    bool isEndReached = false,
    required DocumentSnapshot? cursor,
  }) {
    return copyWith(
      messages: [...this.messages, ...messages],
      isEndReached: isEndReached,
      cursor: cursor,
    );
  }

  ChatMessageList appendToFront(ChatMessage message) {
    return copyWith(messages: [message, ...messages]);
  }
}
