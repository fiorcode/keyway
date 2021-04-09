import 'package:flutter/material.dart';

class TitleTextField extends StatelessWidget {
  const TitleTextField(this.ctrler, this.refreshScreen);

  final TextEditingController ctrler;
  final Function refreshScreen;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: true,
      controller: ctrler,
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
