import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _builtSignIn(),
      ),
    );
  }

  Widget _builtSignIn() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 48.0,
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
            child: SignInForm(),
          ),
          textDivider("or continue with"),
          _SignInButtons(),
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
                    color: Colors.blue[800],
                  )),
            ])),
          )
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _SignInButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 56,
          width: 56,
          child: ElevatedButton(
            child: Image.asset("assets/images/google-logo.png"),
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
            ),
          ),
        ),
        SizedBox(
          width: 28,
        ),
        SizedBox(
          height: 56,
          width: 56,
          child: ElevatedButton(
            child: Image.asset("assets/images/facebook-logo.png"),
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              primary: Color(0xff4267B2),
            ),
          ),
        )
      ],
    );
  }

  Widget textDivider(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              thickness: 1.5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Divider(
              thickness: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  const SignInForm({Key key}) : super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<_SignInFormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              icon: Icon(Icons.person),
              labelText: "Username",
            ),
            validator: (value) {
              if (value == null || value == '') {
                return "Please enter the user credentials...";
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              icon: Icon(Icons.credit_card),
              labelText: "Password",
            ),
            validator: (value) {
              if (value == null || value == '') {
                return "Please enter the user credentials...";
              }
              return null;
            },
          ),
          SizedBox(
            height: 16.0,
          ),
          GestureDetector(
            onTap: () {},
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(color: Colors.blue[800]),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          SizedBox(
            height: 52.0,
            width: 144,
            child: ElevatedButton(
              onPressed: () {},
              child: Text("Sign In"),
            ),
          )
        ],
      ),
    );
  }
}
