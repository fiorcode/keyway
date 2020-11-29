import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WarningHelper {
  static Future<bool> repeatedWarning(
      BuildContext context, String field) async {
    return showDialog<bool>(
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
                Navigator.of(context).pop(false);
              },
              child: Text('CANCEL'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('SAVE', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  static Future<bool> deleteWarning(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.red[400],
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning_amber_outlined, color: Colors.white, size: 32),
              Text(
                ' Delete Database Backup',
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          content: Text(
            'You\'re about to delete your backup from Google Drive. \n\nThis action is PERMANENTLY. \n\nDo you want to proceed?',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            FlatButton(
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('CANCEL'),
            ),
            SizedBox(width: 24),
            FlatButton(
              color: Colors.redAccent[100],
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                'DELETE',
                style: TextStyle(color: Colors.red[900]),
              ),
            ),
          ],
        );
      },
    );
  }
}
