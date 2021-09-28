import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FrinoUser {
  FrinoUser({@required this.uid});

  final String uid;
}

abstract class AuthBase {
  Stream<FrinoUser> get onAuthChanged;
  Future<FrinoUser> currentUser();
  Future<FrinoUser> signInAnonymously();
  Future<FrinoUser> signInWithGoogle();
  Future<void> signOut();
}

class Auth extends AuthBase {
  Auth() {
    _initiliazeFirebase();
  }

  final _firebaseAuth = FirebaseAuth.instance;

  Future<void> _initiliazeFirebase() async {
    await Firebase.initializeApp();
  }

  FrinoUser _userFromFirebase(User user) {
    if (user == null) {
      return null;
    }
    return FrinoUser(uid: user.uid);
  }

  @override
  Stream<FrinoUser> get onAuthChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  @override
  Future<FrinoUser> currentUser() async {
    final user = await _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<FrinoUser> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<FrinoUser> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final authRes = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(
              idToken: googleAuth.idToken, accessToken: googleAuth.accessToken),
        );
        return _userFromFirebase(authRes.user);
      } else {
        throw PlatformException(
          code: "ERROR_MISSING_AUTH",
          message: "Missing Google Auth Token",
        );
      }
    } else {
      throw PlatformException(
        code: "ERROR_ABORTION",
        message: "Sign In aborted by user",
      );
    }
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
