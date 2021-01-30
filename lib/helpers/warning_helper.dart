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

  static Future<bool> deleteDBWarning(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.red[400],
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.warning_amber_outlined, color: Colors.white, size: 92),
              SizedBox(height: 8),
              Text(
                ' Delete Database',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          content: Text(
            'You\'re about to delete ALL your data. \n\nThis action is PERMANENTLY. \n\nDo you want to proceed?',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            FlatButton(
              color: Colors.white,
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('CANCEL'),
            ),
            SizedBox(width: 24),
            FlatButton(
              color: Colors.redAccent[100],
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'DELETE DATABASE',
                style: TextStyle(color: Colors.red[900]),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<bool> deleteItemWarning(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return ButtonBarTheme(
          data: ButtonBarThemeData(alignment: MainAxisAlignment.spaceBetween),
          child: AlertDialog(
            backgroundColor: Colors.red[400],
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.warning, color: Colors.white, size: 92),
                SizedBox(height: 8),
                Text(
                  ' Delete item',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            content: Text(
              'You\'re about to delete this item. \n\nDo you want to proceed?',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            actionsPadding: EdgeInsets.symmetric(horizontal: 8.0),
            actions: [
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('CANCEL', style: TextStyle(color: Colors.white)),
              ),
              FlatButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'DELETE ITEM',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
          ),
        );
      },
    );
  }

  static Future<bool> deleteBackupWarning(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return ButtonBarTheme(
          data: ButtonBarThemeData(alignment: MainAxisAlignment.spaceBetween),
          child: AlertDialog(
            backgroundColor: Colors.red[400],
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.warning, color: Colors.white, size: 92),
                SizedBox(height: 8),
                Text(
                  ' Delete Database Backup',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            content: Text(
              '''You\'re about to delete your backup from Google Drive.
              \n\nThis action is PERMANENTLY.
              \n\nDo you want to proceed?''',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              FlatButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('CANCEL', style: TextStyle(color: Colors.red)),
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'DELETE BACKUP',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<bool> downloadWarning(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blue[400],
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.warning_amber_outlined,
                    color: Colors.white, size: 32),
              ),
              Text(
                'Download \nDatabase Backup',
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          content: Text(
            'You\'re about to download your backup from Google Drive. \n\nThis action will replace your actual database and is PERMANENTLY. \n\nDo you want to proceed?',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('CANCEL'),
                ),
                SizedBox(width: 48),
                FlatButton(
                  color: Colors.blueAccent[100],
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    'DOWNLOAD',
                    style: TextStyle(color: Colors.blue[900]),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
