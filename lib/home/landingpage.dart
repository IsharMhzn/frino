import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frino/authentication/auth/auth.dart';
import 'package:frino/authentication/signin/signin_page.dart';
import 'package:frino/home/home_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: auth.onAuthChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          FrinoUser user = snapshot.data;
          if (user == null) {
            return SignInPage(
              auth: auth,
            );
          } else {
            return HomePage(
              auth: auth,
            );
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
