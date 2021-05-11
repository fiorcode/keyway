import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinTextField extends StatefulWidget {
  PinTextField(this.ctrler, this.refreshScreen);

  final TextEditingController ctrler;
  final Function refreshScreen;

  @override
  _PinTextFieldState createState() => _PinTextFieldState();
}

class _PinTextFieldState extends State<PinTextField> {
  bool _empty = true;
  bool _obscure = false;

  void _onChanged() {
    setState(() => _empty = widget.ctrler.text.isEmpty);
    widget.refreshScreen();
  }

  void _obscureSwitch() => setState(() => _obscure = !_obscure);

  void _clear() => setState(() {
        widget.ctrler.clear();
        _empty = true;
        widget.refreshScreen();
      });

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
      keyboardType: TextInputType.number,
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
        hintText: 'PIN',
        prefixIcon: _empty
            ? null
            : InkWell(
                child: Icon(Icons.visibility),
                onTap: _obscureSwitch,
              ),
        suffixIcon: _empty
            ? null
            : InkWell(
                child: Icon(Icons.clear),
                onTap: _clear,
              ),
      ),
      obscureText: _obscure,
      onChanged: (_) => _onChanged(),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textAlign: TextAlign.center,
    );
  }
}
