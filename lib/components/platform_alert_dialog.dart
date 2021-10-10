import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
