import 'package:flutter/material.dart';

class UsernameTextField extends StatelessWidget {
  const UsernameTextField(this.ctrler, this.function);

  final TextEditingController ctrler;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      controller: ctrler,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 3),
        ),
        filled: true,
        fillColor: Theme.of(context).backgroundColor,
        labelText: 'Username',
      ),
      onChanged: (_) => function(),
    );
  }
}
