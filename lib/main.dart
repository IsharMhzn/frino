import 'package:flutter/material.dart';
import 'package:frino/authentication/signin.dart';

void main() {
  runApp(FrinoApp());
}

class FrinoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignInPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
