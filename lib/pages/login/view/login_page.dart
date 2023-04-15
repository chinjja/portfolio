import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/app/app.dart';
import 'package:portfolio/pages/pages.dart';
import 'package:portfolio/services/services.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(loginProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          context.showSnackbarOk(error.toString());
        },
      );
    });
    final loading = ref.watch(loginProvider).isLoading;
    final user = ref.watch(getCurrentUserProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Portfolio')),
      body: Column(
        children: [
          Text(user?.displayName ?? 'no user'),
          FilledButton(
            onPressed: loading
                ? null
                : () {
                    if (user == null) {
                      ref.read(loginProvider.notifier).login();
                    } else {
                      ref.read(loginProvider.notifier).logout();
                    }
                  },
            child: user == null ? const Text('Login') : const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
