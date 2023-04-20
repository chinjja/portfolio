import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
