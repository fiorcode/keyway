import 'package:flutter/material.dart';

class ErrorHelper {
  static errorDialog(BuildContext context, dynamic e) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error', textAlign: TextAlign.center),
          content: Text(
            e.toString(),
            textAlign: TextAlign.center,
          ),
          actions: [
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  Widget errorBody(dynamic e) => ErrorBody(e);
}

class ErrorBody extends StatelessWidget {
  ErrorBody(this.error);

  final dynamic error;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(64.0),
            child: Image.asset("assets/error.png"),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
