import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/app/app.dart';
import 'package:portfolio/pages/pages.dart';

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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "PJH's Portfolio👋",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                Stack(
                  children: [
                    InkWell(
                      onTap: loading
                          ? null
                          : () {
                              ref.read(loginProvider.notifier).login();
                            },
                      child: Image.asset(
                        'assets/images/google_signin.png',
                      ),
                    ),
                    if (loading)
                      const Positioned.fill(
                          child: Center(child: CircularProgressIndicator()))
                  ],
                ),
                const SizedBox(height: 32),
                TextButton(
                  onPressed: () {
                    context.go('/');
                  },
                  child: const Text('홈으로 돌아가기'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
