import 'package:flutter/material.dart';

class UsernameTextField extends StatelessWidget {
  const UsernameTextField(this.ctrler, this.function, this.focus);

  final TextEditingController ctrler;
  final Function function;
  final FocusNode focus;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      controller: ctrler,
      focusNode: focus,
      decoration: InputDecoration(
        // counterText: '',
        // border: OutlineInputBorder(),
        // enabledBorder: OutlineInputBorder(
        //   borderSide: BorderSide(width: 1),
        // ),
        // focusedBorder: OutlineInputBorder(
        //   borderSide: BorderSide(width: 3),
        // ),
        // filled: true,
        // fillColor: Theme.of(context).backgroundColor,
        hintText: 'Username',
      ),
      maxLength: 128,
      onChanged: (_) => function(),
      textAlign: TextAlign.center,
    );
  }
}
