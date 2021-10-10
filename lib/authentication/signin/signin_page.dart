import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frino/palette.dart';
import 'package:frino/authentication/signin/signin_widgets.dart';

enum SignType { Signin, Register }

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  SignType signtype = SignType.Signin;
  // final GlobalKey<SignInFormState> _childkey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildSignIn(),
        // backgroundColor: Colors.white,
      ),
    );
  }

  void _toggleSignIn() {
    setState(() {
      signtype =
          signtype == SignType.Signin ? SignType.Register : SignType.Signin;
    });
    // _childkey.currentState.passwordcontroller.clear();
    // _childkey.currentState.usernamecontroller.clear();
  }

  Widget _buildSignIn() {
    final List<String> suggestText = signtype == SignType.Signin
        ? ["Don't have an account? ", "Create one"]
        : ["Already have an account? ", "Login"];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
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
                type: signtype,
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
                    text: suggestText[0],
                    style: TextStyle(color: Colors.black)),
                TextSpan(
                    text: suggestText[1],
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _toggleSignIn();
                      },
                    style: TextStyle(
                      color: primaryColor,
                    )),
              ])),
            )
          ],
        ),
      ),
    );
  }
}
