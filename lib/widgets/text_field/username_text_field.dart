import 'package:flutter/material.dart';

class UsernameTextField extends StatelessWidget {
  const UsernameTextField(
    this.ctrler,
    // this.refreshScreen,
    this.focus,
  );

  final TextEditingController ctrler;
  // final Function refreshScreen;
  final FocusNode focus;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      controller: ctrler,
      focusNode: focus,
      decoration: InputDecoration(
        hintText: 'Username',
      ),
      maxLength: 128,
      textAlign: TextAlign.center,
      onChanged: (_) {},
    );
  }
}
