import 'package:flutter/material.dart';

class TitleTextField extends StatelessWidget {
  const TitleTextField(this.ctrler, this.onChanged);

  final TextEditingController ctrler;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: true,
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
        labelText: 'Title',
      ),
      textCapitalization: TextCapitalization.sentences,
      onChanged: (_) => onChanged(),
    );
  }
}
