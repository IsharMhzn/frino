import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frino/authentication/auth/auth.dart';
import 'package:frino/components/platform_alert_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;

  void _signOut() async {
    try {
      await auth.signOut();
      print("Signing out...");
    } catch (e) {
      print(e);
    }
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _confirmSignOut(BuildContext context) async {
    bool didsignOut = await PlatformAlertDialog(
      title: "Logout",
      content: "Are you sure you want to logout?",
      defaultActionText: "OK",
      cancelActionText: "Cancel",
    ).show(context);
    if (didsignOut) {
      widget._signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Frino"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _confirmSignOut(context),
          )
        ],
      ),
    );
  }
}
