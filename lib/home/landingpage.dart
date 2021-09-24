import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frino/authentication/auth/auth.dart';
import 'package:frino/authentication/signin/signin_page.dart';
import 'package:frino/home/home_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  FrinoUser _user;

  @override
  void initState() {
    _checkCurrentUser();
    super.initState();
  }

  void _updateUser(FrinoUser user) {
    setState(() {
      _user = user;
    });
  }

  void _checkCurrentUser() async {
    await Firebase.initializeApp();

    try {
      final FrinoUser user = await widget.auth.currentUser();
      _updateUser(user);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return SignInPage(
        signIn: _updateUser,
        auth: widget.auth,
      );
    } else {
      return HomePage(
        onSignOut: () => _updateUser(null),
        auth: widget.auth,
      );
    }
  }
}
