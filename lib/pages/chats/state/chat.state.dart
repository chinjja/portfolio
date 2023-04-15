import 'package:portfolio/models/models.dart';
import 'package:portfolio/services/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat.state.g.dart';

@riverpod
class GetChat extends _$GetChat {
  @override
  Stream<Chat?> build(String id) {
    return ref.read(chatServiceProvider).get(id);
  }
}

@riverpod
class GetChats extends _$GetChats {
  @override
  Stream<List<Chat>> build() {
    return ref.read(chatServiceProvider).chats;
  }
}
