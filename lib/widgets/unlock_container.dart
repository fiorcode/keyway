import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/cripto_provider.dart';

class UnlockContainer extends StatefulWidget {
  UnlockContainer(this.function);
  final Function function;
  @override
  _UnlockContainerState createState() => _UnlockContainerState();
}

class _UnlockContainerState extends State<UnlockContainer> {
  TextEditingController _ctrler = TextEditingController();
  bool _empty = true;
  bool _obscure = true;

  void _isEmpty() {
    setState(() => _empty = _ctrler.text.isEmpty);
  }

  void _obscureSwitch() {
    setState(() => _obscure = !_obscure);
  }

  @override
  void dispose() {
    _ctrler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _cProv = Provider.of<CriptoProvider>(context);
    return Container(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(64),
            child: TextField(
              autocorrect: false,
              autofocus: true,
              controller: _ctrler,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 3),
                ),
                filled: true,
                fillColor: Colors.white60,
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
                            _cProv.unlock(_ctrler.text);
                            widget.function();
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
            ),
          ),
        ),
      ),
    );
  }
}
