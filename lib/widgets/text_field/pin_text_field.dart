import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinTextField extends StatefulWidget {
  PinTextField(this.ctrler);

  final TextEditingController? ctrler;

  @override
  _PinTextFieldState createState() => _PinTextFieldState();
}

class _PinTextFieldState extends State<PinTextField> {
  late bool _empty;
  bool _obscure = false;

  void _onChanged() {
    setState(() => _empty = widget.ctrler!.text.isEmpty);
  }

  void _obscureSwitch() => setState(() => _obscure = !_obscure);

  void _clear() => setState(() {
        widget.ctrler!.clear();
        _empty = true;
      });

  @override
  void initState() {
    _empty = widget.ctrler!.text.isEmpty;
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
