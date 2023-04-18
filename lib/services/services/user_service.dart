import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:portfolio/models/models.dart';
import 'package:portfolio/providers/providers.dart';
import 'package:portfolio/providers/providers/firebase_messaging_provider.dart';

final userServiceProvider = Provider((ref) => UserService(ref));

class UserService {
  static const prefix = 'users';
  final Ref ref;

  UserService(this.ref) {
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      updateFcmToken(uid: user.uid, fcmToken: token);
    });
  }

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

  Future<Member> createMember(User user) async {
    final firebaseMessaging = ref.read(firebaseMessagingProvider);
    final member = Member(
      uid: user.uid,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      fcmToken: await firebaseMessaging.getToken(),
    );

    final firestore = ref.read(firebaseFirestoreProvider);
    await firestore.collection('members').doc(member.uid).set(member.toJson());
    return member;
  }

  Future<void> updateFcmToken({
    required String uid,
    required String fcmToken,
  }) async {
    final member = await getMemberByUid(uid);
    if (member == null) return;

    final firestore = ref.read(firebaseFirestoreProvider);
    await firestore
        .collection('members')
        .doc(member.uid)
        .set(member.copyWith(fcmToken: fcmToken).toJson());
  }

  Future<Member?> getMemberByUid(String uid) async {
    final firestore = ref.read(firebaseFirestoreProvider);
    final res = await firestore.collection('members').doc(uid).get();
    if (res.exists) return Member.fromJson(res.data()!);
    return null;
  }
}
