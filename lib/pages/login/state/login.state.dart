import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/services/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login.state.g.dart';

@Riverpod(keepAlive: true)
class GetCurrentUser extends _$GetCurrentUser {
  @override
  User? build() {
    final d = FirebaseAuth.instance.authStateChanges().listen((event) {
      state = event;
    });
    ref.onDispose(() {
      d.cancel();
    });
    return FirebaseAuth.instance.currentUser;
  }

  void updateUser(User? user) {
    state = user;
  }
}

@riverpod
class Login extends _$Login {
  @override
  FutureOr<User?> build() {
    return null;
  }

  Future<void> login() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final res = await ref.read(userServiceProvider).login();
      ref.read(getCurrentUserProvider.notifier).updateUser(res);
      return res;
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(userServiceProvider).logout();
      ref.read(getCurrentUserProvider.notifier).updateUser(null);
      return null;
    });
  }
}

final refreshRouterProvider =
    ChangeNotifierProvider((ref) => RefreshRouter(ref));

class RefreshRouter extends ValueNotifier<User?> {
  RefreshRouter(Ref ref) : super(null) {
    ref.listen(getCurrentUserProvider, (previous, next) {
      value = next;
    });
  }
}