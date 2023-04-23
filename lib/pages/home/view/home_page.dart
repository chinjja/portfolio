import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/pages/pages.dart';

class HomePage extends ConsumerWidget {
  final map = const [
    '/dashboard',
    '/projects',
    '/chats',
  ];
  final Widget child;
  const HomePage({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(listenNotificationProvider, (previous, next) {
      next.whenData((value) => ref
          .read(listenNotificationProvider.notifier)
          .showNotification(context, value));
    });
    final location = GoRouter.of(context).location;
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indexOf(location),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.person), label: 'About Me'),
          NavigationDestination(icon: Icon(Icons.list), label: 'Projects'),
          NavigationDestination(icon: Icon(Icons.chat), label: 'Chats'),
        ],
        onDestinationSelected: (value) {
          context.go(map[value]);
        },
      ),
    );
  }

  int _indexOf(String location) {
    for (final i in map.asMap().entries) {
      if (location.startsWith(i.value)) return i.key;
    }
    return 0;
  }
}

class NotificationDialog extends HookConsumerWidget {
  final String chatId;
  final String title;
  final String body;

  const NotificationDialog({
    super.key,
    required this.chatId,
    required this.title,
    required this.body,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMounted = useIsMounted();
    Future.delayed(const Duration(seconds: 2), () {
      if (isMounted()) {
        Navigator.of(context).pop();
      }
    });
    return Align(
      alignment: Alignment.topCenter,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
          context.go('/chats/$chatId');
        },
        child: Card(
          elevation: 4,
          child: ListTile(
            leading: const FlutterLogo(),
            title: Text(title),
            subtitle: Text(body),
          ),
        ),
      ),
    );
  }
}
