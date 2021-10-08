import 'package:flutter/material.dart';
import 'package:frino/authentication/auth/auth.dart';
import 'package:frino/palette.dart';

// ignore: non_constant_identifier_names
// Google and Facebook SignIn buttons
Widget signInButtons(BuildContext context, AuthBase auth) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        height: 56,
        width: 56,
        child: ElevatedButton(
          child: Image.asset("assets/images/google-logo.png"),
          onPressed: auth.signInWithGoogle,
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
          onPressed: auth.signInWithFacebook,
          style: ElevatedButton.styleFrom(
            primary: Color(0xff4267B2),
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
          child: Image.asset("assets/images/twitter-logo.png"),
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
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
  const SignInForm({Key key, @required this.auth}) : super(key: key);
  final Auth auth;

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final usernamecontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  String email, password;
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
            controller: usernamecontroller,
            onTap: requestusernameFocus,
            decoration: InputDecoration(
              icon: Icon(Icons.person,
                  color: usernamefocusNode.hasFocus
                      ? primaryColor
                      : Colors.grey[600]),
              labelText: "Email",
              labelStyle: TextStyle(
                  color: usernamefocusNode.hasFocus
                      ? primaryColor
                      : Colors.grey[600]),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor),
              ),
            ),
            validator: (value) {
              String pattern =
                  r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
              var regEx = RegExp(pattern);
              if (value == null || value == '') {
                return "Please enter the email";
              } else if (!regEx.hasMatch(value)) {
                return "Please enter a valid email";
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onSaved: (email) {
              setState(() {
                this.email = email;
              });
            },
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autocorrect: false,
          ),
          SizedBox(height: 16),
          TextFormField(
            cursorColor: primaryColor,
            focusNode: passwordfocusNode,
            controller: passwordcontroller,
            obscureText: true,
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
                    : Colors.grey[600],
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor),
              ),
            ),
            validator: (value) {
              if (value == null || value == '') {
                return "Please enter the password";
              } else if (value.length < 8) {
                return "Password must be at least 8 characters long";
              } else {
                return null;
              }
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onSaved: (password) {
              setState(() {
                this.password = password;
              });
            },
            textInputAction: TextInputAction.done,
            autocorrect: false,
          ),
          SizedBox(
            height: 20.0,
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
              onPressed: () {
                try {
                  var validated = _formKey.currentState.validate();

                  if (validated == true) {
                    _formKey.currentState.save();
                    widget.auth.signIn(this.email, this.password);
                  }
                } catch (e) {
                  print(e);
                }
              },
              child: Text("Sign In"),
            ),
          )
        ],
      ),
    );
  }
}
