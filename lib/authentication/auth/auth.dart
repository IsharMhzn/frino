import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FrinoUser {
  FrinoUser({@required this.uid});

  final String uid;
}

abstract class AuthBase {
  Stream<FrinoUser> get onAuthChanged;
  Future<FrinoUser> currentUser();
  Future<FrinoUser> signInAnonymously();
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
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
