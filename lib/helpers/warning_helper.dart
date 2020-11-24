import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WarningHelper {
  static repeatedWarning(BuildContext context, String field) async {
    showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$field repeated', textAlign: TextAlign.center),
          content: Text(
            'This $field is already in use, do you want to save it anyway?',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                return false;
              },
              child: Text('CANCEL'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                return true;
              },
              child: Text('SAVE', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
