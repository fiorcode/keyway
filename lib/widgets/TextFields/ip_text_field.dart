import 'package:flutter/material.dart';

class IpTextField extends StatefulWidget {
  IpTextField(this.ctrler);

  final TextEditingController ctrler;

  @override
  _IpTextFieldState createState() => _IpTextFieldState();
}

class _IpTextFieldState extends State<IpTextField> {
  bool _empty = true;
  bool _obscure = true;

  void _isEmpty() {
    setState(() {
      _empty = widget.ctrler.text.isEmpty;
    });
  }

  void _obscureSwitch() {
    setState(() {
      _obscure = !_obscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      controller: widget.ctrler,
      keyboardType: TextInputType.number,
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
        hintText: 'XXX.XXX.XXX.XXX',
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
      onChanged: (_) => _isEmpty(),
      textAlign: TextAlign.center,
    );
  }
}
