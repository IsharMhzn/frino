import 'package:flutter/material.dart';
import 'package:frino/landingpage.dart';
import 'package:frino/palette.dart';

void main() {
  runApp(FrinoApp());
}

class FrinoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LandingPage(),
      theme: ThemeData(primaryColor: primaryColor),
      debugShowCheckedModeBanner: false,
    );
  }
}
