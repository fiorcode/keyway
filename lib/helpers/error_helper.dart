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
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  static Widget errorScaffold(dynamic e) => ErrorScaffold(e);

  static Widget errorBody(dynamic e) => ErrorBody(e);
}

class ErrorScaffold extends StatelessWidget {
  ErrorScaffold(this.error);

  final dynamic error;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Image.asset("assets/error.png", height: 128),
          ),
          Container(
            height: 128,
            child: Center(
              child: Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ErrorBody extends StatelessWidget {
  ErrorBody(this.error);

  final dynamic error;
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(32),
      children: [
        Center(
          child: Image.asset("assets/error.png", height: 128),
        ),
        Center(
          child: Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
            overflow: TextOverflow.fade,
          ),
        ),
      ],
    );
  }
}
