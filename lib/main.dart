import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frino/home/landingpage.dart';
import 'authentication/auth/auth.dart';
import 'package:frino/palette.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(FrinoApp());
}

class FrinoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LandingPage(
        auth: Auth(),
      ),
      theme: ThemeData(primaryColor: primaryColor),
      debugShowCheckedModeBanner: false,
    );
  }
}
