import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/pages/pages.dart';
import 'package:portfolio/widgets/widgets.dart';

class ChatPage extends HookConsumerWidget {
  final String id;

  const ChatPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chat = ref.watch(getChatProvider(id)).valueOrNull;
    return Scaffold(
      appBar: AppBar(
        title: Text(chat?.id ?? ''),
      ),
      body: ChatView(id: id),
    );
  }
}

class ChatView extends HookConsumerWidget {
  final String id;

  const ChatView({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chat = ref.watch(getChatProvider(id));
    return chat.when(
      loading: () => const LoadingView(),
      error: (error, stackTrace) => Text(error.toString()),
      data: (data) => data == null
          ? const Text('Not exists')
          : Column(
              children: [
                Text(data.id),
              ],
            ),
    );
  }
}
