import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frino/authentication/auth/auth.dart';
import 'package:frino/authentication/signin/signin_page.dart';
import 'package:frino/components/platform_alert_dialog.dart';
import 'package:frino/palette.dart';
import 'package:provider/provider.dart';

// ignore: non_constant_identifier_names
// Google and Facebook SignIn buttons
Widget signInButtons(BuildContext context) {
  final auth = Provider.of<AuthBase>(context);
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
      // TODO: authentication with twitter
      // SizedBox(
      //   height: 56,
      //   width: 56,
      //   child: ElevatedButton(
      //     child: Image.asset("assets/images/twitter-logo.png"),
      //     onPressed: () {},
      //     style: ElevatedButton.styleFrom(
      //       primary: Colors.white,
      //     ),
      //   ),
      // )
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
  const SignInForm({Key key, @required this.type}) : super(key: key);
  final SignType type;

  @override
  SignInFormState createState() => SignInFormState();
}

class SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final usernamecontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final namecontroller = TextEditingController();
  String email, password, name;
  bool _isLoading = false;
  FocusNode usernamefocusNode = new FocusNode();
  FocusNode passwordfocusNode = new FocusNode();
  FocusNode namefocusNode = new FocusNode();

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

  void requestnameFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(namefocusNode);
    });
  }

  void _submitForm() async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      var validated = _formKey.currentState.validate();

      if (validated == true) {
        _formKey.currentState.save();
        if (this.mounted) {
          setState(() {
            _isLoading = true;
          });
        }

        // print("submitting...");
        // await Future.delayed(Duration(seconds: 3));
        if (widget.type == SignType.Signin) {
          await auth.signIn(this.email, this.password);
        } else {
          await auth.createUser(this.email, this.password, this.name);
        }
      }
    } on FirebaseAuthException catch (e) {
      PlatformExceptionAlertDialog(
        title: "Sign In Failed",
        exception: e,
      ).show(context);
    } catch (e) {
      print(e.toString());
    } finally {
      if (this.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          widget.type == SignType.Register
              ? TextFormField(
                  cursorColor: primaryColor,
                  focusNode: namefocusNode,
                  controller: namecontroller,
                  onTap: requestnameFocus,
                  decoration: InputDecoration(
                    icon: Icon(Icons.text_fields,
                        color: usernamefocusNode.hasFocus
                            ? primaryColor
                            : Colors.grey[600]),
                    labelText: "Name",
                    labelStyle: TextStyle(
                        color: usernamefocusNode.hasFocus
                            ? primaryColor
                            : Colors.grey[600]),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onSaved: (name) {
                    setState(() {
                      this.name = name;
                    });
                  },
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  autocorrect: false,
                  enabled: _isLoading == false,
                )
              : Container(),
          SizedBox(height: 16),
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
            enabled: _isLoading == false,
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
            enabled: _isLoading == false,
          ),
          SizedBox(
            height: 20.0,
          ),
          widget.type == SignType.Signin
              ? GestureDetector(
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
                )
              : Container(),
          SizedBox(
            height: 16.0,
          ),
          SizedBox(
            height: 52.0,
            width: 144,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: primaryColor),
              onPressed: !_isLoading ? _submitForm : null,
              child: !this._isLoading
                  ? Text(
                      widget.type == SignType.Signin ? "Sign In" : "Sign Up",
                    )
                  : CircularProgressIndicator(
                      // backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
