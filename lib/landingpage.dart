import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frino/authentication/signin/signin_page.dart';
import 'package:frino/home/home_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  User _user;

  @override
  void initState() {
    _checkCurrentUser();
    super.initState();
  }

  void _updateUser(User user) {
    setState(() {
      _user = user;
    });
  }

  void _checkCurrentUser() async {
    await Firebase.initializeApp();

    try {
      final User user = await FirebaseAuth.instance.currentUser;
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
      );
    } else {
      return HomePage(
        onSignOut: () => _updateUser(null),
      );
    }
  }
}
