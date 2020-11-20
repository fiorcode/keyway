import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WarningHelper {
  static passRepeatedWarning(BuildContext context, Function f) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Password repeated', textAlign: TextAlign.center),
          content: Text(
            'This password is already in use, do you want to save it anyway?',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('CANCEL'),
            ),
            FlatButton(
              onPressed: f,
              child: Text('SAVE', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
