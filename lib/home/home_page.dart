import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frino/authentication/auth/auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key, @required this.onSignOut, @required this.auth})
      : super(key: key);
  final AuthBase auth;
  final VoidCallback onSignOut;

  void _signOut() async {
    await Firebase.initializeApp();

    try {
      await auth.signOut();
      onSignOut();
      print("Signing out...");
    } catch (e) {
      print(e);
    }
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Frino"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: widget._signOut,
          )
        ],
      ),
    );
  }
}
