import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:portfolio/models/models.dart';
import 'package:portfolio/providers/providers.dart';
import 'package:portfolio/services/services.dart';
import 'package:portfolio/services/services/fcm_service.dart';
import 'package:rxdart/rxdart.dart';

final userServiceProvider = Provider((ref) => UserService(ref));

class UserService {
  static const prefix = 'users';
  final Ref ref;
  StreamSubscription? fcmSubscription;

  UserService(this.ref) {
    authStateChanges().throttleTime(const Duration(seconds: 1)).listen((user) {
      if (user != null) {
        _initialize(user);
      }
    });
  }

  Future<void> _initialize(User user) async {
    await ref.read(firebaseMessagingProvider).requestPermission();

    final token = await ref.read(fcmServiceProvider).getToken();
    updateMember(user, fcmToken: token);
    fcmSubscription?.cancel();

    final fcmService = ref.read(fcmServiceProvider);
    fcmSubscription = fcmService.onTokenRefresh.listen((token) {
      final user = currentUser;
      if (user == null) return;
      updateMember(user, fcmToken: token);
    });
  }

  Stream<User?> authStateChanges() =>
      ref.read(firebaseAuthProvider).authStateChanges();

  Future<User> login() async {
    UserCredential credential;

    final firebaseAuth = ref.read(firebaseAuthProvider);
    if (kIsWeb) {
      final authProvider = GoogleAuthProvider();
      credential = await firebaseAuth.signInWithPopup(authProvider);
    } else {
      final googleSignIn = GoogleSignIn();
      final user = await googleSignIn.signIn();
      final auth = await user!.authentication;
      final oauth = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );
      credential = await firebaseAuth.signInWithCredential(oauth);
    }
    return credential.user!;
  }

  Future<void> logout() async {
    fcmSubscription?.cancel();
    fcmSubscription = null;
    final user = currentUser;
    if (user != null) {
      await updateMember(user, fcmToken: null);
    }
    final firebaseAuth = ref.read(firebaseAuthProvider);
    await firebaseAuth.signOut();
  }

  User? get currentUser => ref.read(firebaseAuthProvider).currentUser;

  Stream<String> get ownerUid {
    final firestore = ref.read(firebaseFirestoreProvider);
    return firestore
        .collection('portfolio')
        .doc('owner')
        .snapshots()
        .map((e) => e.data()!['uid']);
  }

  Future<Member> updateMember(
    User user, {
    String? fcmToken,
  }) async {
    final member = Member(
      uid: user.uid,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      fcmToken: fcmToken,
    );

    final firestore = ref.read(firebaseFirestoreProvider);
    await firestore.collection('members').doc(member.uid).set(member.toJson());
    ref.read(chatServiceProvider).updateFcmToken(user, fcmToken: fcmToken);
    return member;
  }

  Future<Member?> getMemberByUid(String uid) async {
    final firestore = ref.read(firebaseFirestoreProvider);
    final res = await firestore.collection('members').doc(uid).get();
    if (res.exists) return Member.fromJson(res.data()!);
    return null;
  }
}
