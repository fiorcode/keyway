import 'package:flutter/material.dart';

class LongTextTextField extends StatefulWidget {
  LongTextTextField(this.ctrler);

  final TextEditingController ctrler;

  @override
  _LongTextTextFieldState createState() => _LongTextTextFieldState();
}

class _LongTextTextFieldState extends State<LongTextTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      controller: widget.ctrler,
      keyboardType: TextInputType.multiline,
      maxLength: 512,
      maxLines: 32,
      decoration: InputDecoration(
        border: InputBorder.none,
        // enabledBorder: OutlineInputBorder(
        //   borderSide: BorderSide(width: 1),
        // ),
        // focusedBorder: OutlineInputBorder(
        //   borderSide: BorderSide(width: 3),
        // ),
        // filled: true,
        // fillColor: Theme.of(context).backgroundColor,
        hintText: 'Note',
      ),
      onChanged: (_) {},
    );
  }
}
