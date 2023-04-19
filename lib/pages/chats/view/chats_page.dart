import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:portfolio/app/app.dart';
import 'package:portfolio/models/models.dart';
import 'package:portfolio/pages/pages.dart';
import 'package:portfolio/widgets/widgets.dart';

class ChatsPage extends HookConsumerWidget {
  const ChatsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(getCurrentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('채팅'),
        actions: [
          if (user != null) ...[
            const _Logout(),
            const _Add(),
          ],
        ],
      ),
      body: const _ChatList(),
    );
  }
}

class _ChatList extends HookConsumerWidget {
  const _ChatList();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(getCurrentUserProvider);
    final chats = ref.watch(getChatsByUidProvider(user!.uid));
    return chats.when(
      loading: () => const LoadingView(),
      error: (error, stackTrace) => Text(error.toString()),
      data: (data) => ListView.separated(
        itemCount: data.length,
        itemBuilder: (context, index) => ChatTile(
          key: ValueKey(data[index].id),
          chat: data[index],
        ),
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }
}

class ChatTile extends HookConsumerWidget {
  final Chat chat;

  const ChatTile({super.key, required this.chat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarUrl = ref.watch(getChatAvatarUrlProvider(chat.id)).valueOrNull;
    final title = ref.watch(getChatTitleProvider(chat.id)).valueOrNull;
    final latestMessage =
        ref.watch(getLatestMessagesByChatIdProvider(chat.id)).valueOrNull;
    return ListTile(
      leading: SizedBox(
        width: 48,
        height: 48,
        child: CircleAvatar(
          backgroundImage: avatarUrl == null ? null : NetworkImage(avatarUrl),
        ),
      ),
      title: Row(
        children: [
          Text(title ?? '제목없음'),
          const SizedBox(width: 12),
          Text(
            DateFormat.yMd()
                .add_jm()
                .format(latestMessage?.date ?? DateTime.now()),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      subtitle: Text(latestMessage?.message ?? '', maxLines: 1),
      onTap: () {
        context.go('/chats/${chat.id}');
      },
    );
  }
}

class _Logout extends HookConsumerWidget {
  const _Logout();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(logoutProvider, (previous, next) {
      next.whenOrNull(
        data: (data) {
          context.go('/');
        },
        error: (error, stackTrace) {
          context.showSnackbarOk(error.toString());
        },
      );
    });
    final loading = ref.watch(logoutProvider).isLoading;
    return TextButton(
      onPressed: loading
          ? null
          : () {
              ref.read(logoutProvider.notifier).logout();
            },
      child: const Text('Logout'),
    );
  }
}

class _Add extends HookConsumerWidget {
  const _Add({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(getCurrentUserProvider);
    if (user == null) return const SizedBox.shrink();

    final provider = createDirectChatProvider(user.uid);
    ref.listen(
      provider,
      (previous, next) {
        next.whenOrNull(
          data: (data) {
            context.go('/chats/${data!.id}');
          },
          error: (error, stackTrace) {
            context.showSnackbarOk(error.toString());
          },
        );
      },
    );

    final loading = ref.watch(provider).isLoading;
    return IconButton(
      onPressed: loading
          ? null
          : () {
              ref.read(provider.notifier).create();
            },
      icon: const Icon(Icons.send),
    );
  }
}
