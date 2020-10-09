import 'package:flutter/material.dart';

class ErrorBody extends StatelessWidget {
  ErrorBody(this.message);

  final String message;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
            child: Padding(
          padding: const EdgeInsets.all(64.0),
          child: Image.asset("assets/error.png"),
        )),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
