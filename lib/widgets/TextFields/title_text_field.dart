import 'package:flutter/material.dart';

class TitleTextField extends StatelessWidget {
  const TitleTextField(this.ctrler, this.refreshScreen, this.focus);

  final TextEditingController ctrler;
  final Function refreshScreen;
  final FocusNode focus;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: true,
      controller: ctrler,
      focusNode: focus,
      decoration: InputDecoration(
        border: InputBorder.none,
        counterText: '',
        hintText: 'Title',
        hintStyle: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      maxLength: 64,
      textAlign: TextAlign.center,
      textCapitalization: TextCapitalization.sentences,
      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      onChanged: (_) => refreshScreen(),
    );
  }
}
