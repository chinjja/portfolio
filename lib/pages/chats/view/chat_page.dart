import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/app/app.dart';
import 'package:portfolio/pages/pages.dart';
import 'package:portfolio/widgets/widgets.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as cu;

class ChatPage extends HookConsumerWidget {
  final String chatId;

  const ChatPage({super.key, required this.chatId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = ref.watch(getChatTitleProvider(chatId)).valueOrNull;
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? '제목없음'),
      ),
      body: ChatView(chatId: chatId),
    );
  }
}

class ChatView extends HookConsumerWidget {
  final String chatId;

  const ChatView({super.key, required this.chatId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(getCurrentUserProvider);
    if (user == null) {
      return const Text('로그인을 하세요.');
    }
    final provider = sendMessageProvider(chatId);
    final messages = ref.watch(getMessagesByChatIdProvider(chatId));
    final member = ref.watch(memberByUidProvider(user.uid)).valueOrNull;
    ref.listen(provider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          context.showSnackbarOk(error.toString());
        },
      );
    });
    return messages.when(
      loading: () => const LoadingView(),
      error: (error, stackTrace) => Text(error.toString()),
      data: (data) => cu.Chat(
        messages: data.map((e) {
          final member = ref.watch(memberByUidProvider(e.uid)).valueOrNull;
          return types.TextMessage(
            id: e.id,
            author: types.User(
              id: e.uid,
              imageUrl: member?.photoUrl,
              lastName: member?.displayName,
            ),
            text: e.message,
            createdAt: e.date?.millisecondsSinceEpoch,
          );
        }).toList(),
        onSendPressed: (text) {
          ref.read(provider.notifier).send(text.text);
        },
        user: types.User(
          id: user.uid,
          imageUrl: member?.photoUrl,
          lastName: member?.displayName,
        ),
        showUserAvatars: true,
        showUserNames: true,
      ),
    );
  }
}
