import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:portfolio/providers/providers.dart';

final userServiceProvider = Provider((ref) => UserService(ref));

class UserService {
  static const prefix = 'users';
  final Ref ref;

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
}
