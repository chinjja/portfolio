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
