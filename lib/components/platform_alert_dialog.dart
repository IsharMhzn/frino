import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frino/components/platformwidget.dart';
import 'package:frino/palette.dart';

class PlatformAlertDialog extends PlatformWidget {
  PlatformAlertDialog(
      {@required this.title,
      @required this.content,
      @required this.defaultActionText,
      this.cancelActionText})
      : assert(title != null),
        assert(content != null),
        assert(defaultActionText != null);

  final String title, content, defaultActionText, cancelActionText;

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(this.title),
      content: Text(this.content),
      actions: _buildActions(context),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text(this.title),
      content: Text(this.content),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    List<Widget> actions = [];
    if (this.cancelActionText != null) {
      actions.add(PlatformAlertDialogButton(
          child: Text(this.cancelActionText),
          onPressed: () {
            Navigator.of(context).pop(false);
          }));
    }
    actions.add(PlatformAlertDialogButton(
        child: Text(this.defaultActionText),
        onPressed: () {
          Navigator.of(context).pop(true);
        }));
    return actions;
  }

  Future<bool> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog(
            context: context, builder: (context) => this)
        : await showDialog(context: context, builder: (context) => this);
  }
}

class PlatformAlertDialogButton extends PlatformWidget {
  PlatformAlertDialogButton({@required this.child, @required this.onPressed});
  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      onPressed: this.onPressed,
      child: this.child,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return TextButton(
      onPressed: this.onPressed,
      child: this.child,
      style:
          ButtonStyle(foregroundColor: MaterialStateProperty.all(primaryColor)),
    );
  }
}

class PlatformExceptionAlertDialog extends PlatformAlertDialog {
  PlatformExceptionAlertDialog({@required this.title, this.exception})
      : super(
            title: title,
            content: _loadContent(exception),
            defaultActionText: "OK");

  final String title;
  final FirebaseAuthException exception;

  static Map<String, String> errorCodes = {
    "email-already-in-use": "The email address is already taken",
    "invalid-email": "The email address is invalid",
    "operation-not-allowed": "This method of signing up is invalid",
    "weak-password": "The password is not strong",
    "user-disabled": "This user account has been disabled",
    "user-not-found": "There is no user corresponding to the email",
    "wrong-password": "The user credentials entered are wrong"
  };

  static String _loadContent(FirebaseAuthException exception) {
    return errorCodes[exception.code] ?? exception.message;
  }
}
