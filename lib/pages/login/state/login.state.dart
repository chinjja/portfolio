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
    final userService = ref.read(userServiceProvider);
    final d = userService.authStateChanges().listen((event) {
      state = event;
    });
    ref.onDispose(() {
      d.cancel();
    });
    return userService.currentUser;
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
      return await ref.read(userServiceProvider).login();
    });
  }
}

@riverpod
class Logout extends _$Logout {
  @override
  FutureOr<User?> build() {
    return null;
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(userServiceProvider).logout();
      return null;
    });
  }
}

@riverpod
class GetOwnerUid extends _$GetOwnerUid {
  @override
  Stream<String> build() {
    return ref.read(userServiceProvider).ownerUid;
  }
}

@riverpod
class IsOwner extends _$IsOwner {
  @override
  bool build() {
    final user = ref.watch(getCurrentUserProvider);
    final ownerUid = ref.watch(getOwnerUidProvider).valueOrNull;
    return user != null && user.uid == ownerUid;
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
