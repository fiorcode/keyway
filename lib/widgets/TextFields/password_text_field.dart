import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  PasswordTextField(this.ctrler, this.refreshScreen, this.focus);

  final TextEditingController ctrler;
  final Function refreshScreen;
  final FocusNode focus;

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _empty = true;
  bool _obscure = true;

  void _onChanged() {
    setState(() => _empty = widget.ctrler.text.isEmpty);
    widget.refreshScreen();
  }

  void _obscureSwitch() {
    setState(() => _obscure = !_obscure);
  }

  void _clear() {
    widget.ctrler.clear();
    _empty = true;
    widget.refreshScreen();
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
      focusNode: widget.focus,
      decoration: InputDecoration(
        // border: OutlineInputBorder(),
        // enabledBorder: OutlineInputBorder(
        //   borderSide: BorderSide(width: 1),
        // ),
        // focusedBorder: OutlineInputBorder(
        //   borderSide: BorderSide(width: 3),
        // ),
        filled: true,
        fillColor: Theme.of(context).backgroundColor,
        labelText: 'Password',
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
    );
  }
}
