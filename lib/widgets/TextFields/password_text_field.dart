import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  PasswordTextField(this.ctrler, this.function);

  final TextEditingController ctrler;
  final Function function;

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _empty = true;
  bool _obscure = true;

  void _onChange() {
    setState(() => _empty = widget.ctrler.text.isEmpty);
    widget.function();
  }

  void _obscureSwitch() {
    setState(() => _obscure = !_obscure);
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
                onTap: () => widget.ctrler.clear(),
              ),
      ),
      obscureText: _obscure,
      onChanged: (_) => _onChange(),
    );
  }
}
