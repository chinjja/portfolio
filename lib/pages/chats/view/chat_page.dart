import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/app/app.dart';
import 'package:portfolio/models/models.dart';
import 'package:portfolio/pages/pages.dart';
import 'package:portfolio/services/services.dart';
import 'package:portfolio/widgets/widgets.dart';

class ChatPage extends HookConsumerWidget {
  final String chatId;

  const ChatPage({super.key, required this.chatId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chat = ref.watch(getChatProvider(chatId)).valueOrNull;
    return Scaffold(
      appBar: AppBar(
        title: Text(chat?.id ?? ''),
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
    final controller = useTextEditingController();
    ref.listen(provider, (previous, next) {
      next.whenOrNull(
        data: (data) {
          controller.clear();
        },
        error: (error, stackTrace) {
          context.showSnackbarOk(error.toString());
        },
      );
    });
    final loading = ref.watch(provider).isLoading;
    final enable = useState(false);
    return messages.when(
      loading: () => const LoadingView(),
      error: (error, stackTrace) => Text(error.toString()),
      data: (data) => SafeArea(
        child: Column(
          children: [
            Expanded(
              child: data.isEmpty
                  ? const Text('No Message')
                  : ListView.builder(
                      reverse: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final message = data[index];
                        return _MessageTile(
                          key: ValueKey(message.id),
                          message: message,
                        );
                      },
                    ),
            ),
            const Divider(height: 0),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: '메시지를 입력하세요.',
                suffix: IconButton(
                  onPressed: loading || !enable.value
                      ? null
                      : () {
                          ref.read(provider.notifier).send(controller.text);
                        },
                  icon: loading
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.send),
                ),
              ),
              onChanged: (value) {
                enable.value = value.isNotEmpty;
              },
              onEditingComplete: loading || !enable.value
                  ? null
                  : () {
                      ref.read(provider.notifier).send(controller.text);
                    },
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageTile extends HookConsumerWidget {
  final ChatMessage message;
  const _MessageTile({super.key, required this.message});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(message.message),
      subtitle: Text(message.uid),
    );
  }
}
