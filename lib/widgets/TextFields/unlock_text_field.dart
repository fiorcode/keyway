import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/cripto_provider.dart';

class UnlockTextField extends StatefulWidget {
  UnlockTextField(this.ctrler);

  final TextEditingController ctrler;

  @override
  _UnlockTextFieldState createState() => _UnlockTextFieldState();
}

class _UnlockTextFieldState extends State<UnlockTextField> {
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
    final _cProv = Provider.of<CriptoProvider>(context);
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
                child: Icon(Icons.vpn_key),
                onTap: () {
                  try {
                    _cProv.unlock(widget.ctrler.text);
                  } catch (error) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Wrong Password'),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.red[300],
                      ),
                    );
                  }
                },
              ),
      ),
      obscureText: _obscure,
      onChanged: (_) => _isEmpty(),
    );
  }
}
