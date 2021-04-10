import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WarningHelper {
  static Future<bool> repeat(BuildContext context, String field) async {
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
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('CANCEL'),
            ),
            TextButton(
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

  static Future<bool> deleteDB(BuildContext context) async {
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
                Icon(Icons.warning_amber_outlined,
                    color: Colors.white, size: 92),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Delete database',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            content: Text(
              '''You\'re about to delete ALL your data.
              \nThis action is PERMANENTLY.
              \nDo you want to proceed?''',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            actionsPadding: EdgeInsets.symmetric(horizontal: 8.0),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('cancel', style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'delete database',
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

  static Future<bool> deleteItem(BuildContext context) async {
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Delete item',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            content: Text(
              'You\'re about to delete this item.\nDo you want to proceed?',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            actionsPadding: EdgeInsets.symmetric(horizontal: 8.0),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('cancel', style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'delete item',
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

  static Future<bool> deleteBackup(BuildContext context) async {
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Delete database backup',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            content: Text(
              '''You\'re about to delete your backup from Google Drive.
              \nThis action is PERMANENTLY.
              \nDo you want to proceed?''',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            actionsPadding: EdgeInsets.symmetric(horizontal: 8.0),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('cancel', style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'delete backup',
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

  static Future<bool> download(BuildContext context) async {
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
                Icon(Icons.warning, color: Colors.white, size: 64),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Download database backup',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            content: Text(
              '''You\'re about to download your backup from Google Drive.
              \nThis action will replace your actual database and is PERMANENTLY.
              \nDo you want to proceed?''',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            actionsPadding: EdgeInsets.symmetric(horizontal: 8.0),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('cancel', style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'download',
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
}
