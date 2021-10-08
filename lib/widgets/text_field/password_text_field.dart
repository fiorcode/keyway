import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:keyway/helpers/password_helper.dart';

class PasswordTextField extends StatefulWidget {
  PasswordTextField(this.ctrler, this.updateView);

  final TextEditingController ctrler;
  final Function updateView;
  // final FocusNode focus;

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _empty = true;
  bool _obscure = false;

  void _onChanged() {
    setState(() => _empty = widget.ctrler.text.isEmpty);
    widget.updateView();
  }

  void _obscureSwitch() {
    setState(() => _obscure = !_obscure);
  }

  void _clear() {
    widget.ctrler.clear();
    _empty = true;
    widget.updateView();
  }

  @override
  void initState() {
    _empty = widget.ctrler.text.isEmpty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      controller: widget.ctrler,
      // focusNode: widget.focus,
      inputFormatters: [
        FilteringTextInputFormatter.allow(PasswordHelper.validRegExp),
      ],
      decoration: InputDecoration(
        hintText: 'Password',
        prefixIcon: _empty
            ? null
            : InkWell(
                child: Icon(
                  Icons.visibility,
                ),
                onTap: _obscureSwitch,
              ),
        suffixIcon: _empty
            ? null
            : InkWell(
                child: Icon(Icons.clear),
                onTap: _clear,
              ),
      ),
      maxLength: 128,
      obscureText: _obscure,
      onChanged: (_) => _onChanged(),
      textAlign: TextAlign.center,
    );
  }
}
