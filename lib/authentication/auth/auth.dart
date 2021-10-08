import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
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
  Future<FrinoUser> signInWithFacebook();
  Future<FrinoUser> signIn(email, password);
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
  Future<FrinoUser> signInWithFacebook() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['public_profile']);
    if (result.accessToken != null) {
      final authRes = await _firebaseAuth.signInWithCredential(
          FacebookAuthProvider.credential(result.accessToken.token));
      return _userFromFirebase(authRes.user);
    } else {
      throw PlatformException(
        code: "ERROR_ABORTION",
        message: "Sign In aborted by user",
      );
    }
  }

  @override
  Future<FrinoUser> signIn(email, password) async {
    final authRes = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authRes.user);
  }

  @override
  Future<void> signOut() async {
    final facebookLogin = FacebookLogin();
    final googleSignIn = GoogleSignIn();
    await facebookLogin.logOut();
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
