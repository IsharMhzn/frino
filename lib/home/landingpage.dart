import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frino/authentication/auth/auth.dart';
import 'package:frino/authentication/signin/signin_page.dart';
import 'package:frino/home/home_page.dart';
import 'package:frino/home/note/note.dart';
import 'package:frino/services/databaseservice.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return StreamBuilder(
      stream: auth.onAuthChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          FrinoUser user = snapshot.data;
          if (user == null) {
            return SignInPage();
          } else {
            return StreamProvider<List<FriNote>>.value(
                value: DatabaseService(uid: user.uid).frinos,
                initialData: null,
                child: HomePage(user: user));
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
