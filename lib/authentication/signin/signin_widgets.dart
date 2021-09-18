import 'package:flutter/material.dart';
import 'package:frino/palette.dart';

// ignore: non_constant_identifier_names
// Google and Facebook SignIn buttons
Widget signInButtons(BuildContext context) {
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

// Text Divider between signin containers
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

// SignIn Form
class SignInForm extends StatefulWidget {
  const SignInForm({Key key, this.signIn}) : super(key: key);
  final VoidCallback signIn;

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<_SignInFormState>();
  FocusNode usernamefocusNode = new FocusNode();
  FocusNode passwordfocusNode = new FocusNode();

  @override
  void initState() {
    super.initState();
  }

  void requestusernameFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(usernamefocusNode);
    });
  }

  void requestpasswdFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(passwordfocusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            cursorColor: primaryColor,
            focusNode: usernamefocusNode,
            onTap: requestusernameFocus,
            decoration: InputDecoration(
              icon: Icon(Icons.person,
                  color: usernamefocusNode.hasFocus
                      ? primaryColor
                      : Colors.grey[600]),
              labelText: "Username",
              labelStyle: TextStyle(
                  color: usernamefocusNode.hasFocus
                      ? primaryColor
                      : Colors.grey[600]),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor),
              ),
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
            cursorColor: primaryColor,
            focusNode: passwordfocusNode,
            onTap: requestpasswdFocus,
            decoration: InputDecoration(
              icon: Icon(
                Icons.credit_card,
                color: passwordfocusNode.hasFocus
                    ? primaryColor
                    : Colors.grey[600],
              ),
              labelText: "Password",
              labelStyle: TextStyle(
                  color: passwordfocusNode.hasFocus
                      ? primaryColor
                      : Colors.grey[600]),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor),
              ),
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
                  style: TextStyle(color: primaryColor),
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
              style: ElevatedButton.styleFrom(primary: primaryColor),
              onPressed: widget.signIn,
              child: Text("Sign In"),
            ),
          )
        ],
      ),
    );
  }
}
