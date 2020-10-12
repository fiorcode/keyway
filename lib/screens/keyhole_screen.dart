import 'package:flutter/material.dart';

import '../widgets/TextFields/unlock_text_field.dart';

class KeyholeScreen extends StatelessWidget {
  static const routeName = '/keyhole';

  _lock() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(),
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: UnlockTextField(_lock),
          ),
        ),
      ),
    );
  }
}
