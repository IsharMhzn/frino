import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frino/palette.dart';
import 'package:frino/authentication/signin/signin_widgets.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key, @required this.signIn}) : super(key: key);
  final Function(User) signIn;

  Future<void> _signInAnonymously() async {
    await Firebase.initializeApp();

    try {
      final userRes = await FirebaseAuth.instance.signInAnonymously();
      signIn(userRes.user);
      print("Signing In ${userRes.user.uid}");
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _builtSignIn(context),
        // backgroundColor: Colors.white,
      ),
    );
  }

  Widget _builtSignIn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 72.0,
          ),
          Center(
            child: Text(
              "Frino",
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 56.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SignInForm(
              signIn: _signInAnonymously,
            ),
          ),
          textDivider("or continue with"),
          signInButtons(context),
          SizedBox(
            height: 32.0,
          ),
          Center(
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: "Don't have an account? ",
                  style: TextStyle(color: Colors.black)),
              TextSpan(
                  text: "Create one",
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      print('The Create one button is clicked!');
                    },
                  style: TextStyle(
                    color: primaryColor,
                  )),
            ])),
          )
        ],
      ),
    );
  }
}
