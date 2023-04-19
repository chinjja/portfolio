import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:portfolio/models/models.dart';
import 'package:portfolio/providers/providers.dart';

final userServiceProvider = Provider((ref) => UserService(ref));

class UserService {
  static const prefix = 'users';
  final Ref ref;
  StreamSubscription? fcmSubscription;

  UserService(this.ref);

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
    final user = credential.user!;
    final firebaseMessaging = ref.read(firebaseMessagingProvider);
    await firebaseMessaging.requestPermission();
    final fcmToken = await firebaseMessaging.getToken(
        vapidKey:
            'BCBTAiZ53Yb34xaAgX_zwprwf5qS4R1UdFdDZr4YFQ-cgOJHMHOrUkLqZ7hLqjQK3vI2F683bKjSTw551GI3EDM');
    final member = await getMemberByUid(user.uid);
    if (member == null) {
      createMember(user, fcmToken: fcmToken);
    } else {
      updateFcmToken(uid: user.uid, fcmToken: fcmToken);
    }
    fcmSubscription?.cancel();
    fcmSubscription = firebaseMessaging.onTokenRefresh.listen((token) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      updateFcmToken(uid: user.uid, fcmToken: token);
    });
    return credential.user!;
  }

  Future<void> logout() async {
    fcmSubscription?.cancel();
    fcmSubscription = null;
    final firebaseAuth = ref.read(firebaseAuthProvider);
    await firebaseAuth.signOut();
  }

  Stream<User?> get user {
    final firebaseAuth = ref.read(firebaseAuthProvider);
    return firebaseAuth.authStateChanges();
  }

  Stream<String> get ownerUid {
    final firestore = ref.read(firebaseFirestoreProvider);
    return firestore
        .collection('portfolio')
        .doc('owner')
        .snapshots()
        .map((e) => e.data()!['uid']);
  }

  Future<Member> createMember(
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
    return member;
  }

  Future<void> updateFcmToken({
    required String uid,
    required String? fcmToken,
  }) async {
    final firestore = ref.read(firebaseFirestoreProvider);
    await firestore
        .collection('members')
        .doc(uid)
        .update({'fcmToken': fcmToken});
  }

  Future<Member?> getMemberByUid(String uid) async {
    final firestore = ref.read(firebaseFirestoreProvider);
    final res = await firestore.collection('members').doc(uid).get();
    if (res.exists) return Member.fromJson(res.data()!);
    return null;
  }
}
