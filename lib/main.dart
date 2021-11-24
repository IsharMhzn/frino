import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frino/home/landingpage.dart';
import 'package:provider/provider.dart';
import 'authentication/auth/auth.dart';
import 'package:frino/palette.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(FrinoApp());
  // SystemChrome.setSystemUIOverlayStyle(
  //     SystemUiOverlayStyle(statusBarColor: primaryColor));
}

class FrinoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        home: LandingPage(),
        theme: ThemeData(primaryColor: primaryColor),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
