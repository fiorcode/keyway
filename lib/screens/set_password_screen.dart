import 'package:flutter/material.dart';
import 'package:keyway/helpers/error_helper.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/cripto_provider.dart';
import 'package:keyway/widgets/check_board.dart';

import 'restore_screen.dart';
import 'items_screen.dart';

class SetPasswordScreen extends StatefulWidget {
  static const routeName = '/set-password';

  @override
  _SetPasswordScreenState createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final _passCtrler = TextEditingController();
  final _confirmCtrler = TextEditingController();

  CriptoProvider cripto;

  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _minLong = false;
  bool _maxLong = false;
  bool _hasLow = false;
  bool _hasUpp = false;
  bool _hasNum = false;
  bool _special = false;
  bool _valid = false;
  bool _equals = false;

  _checkPassword() {
    _confirmCtrler.clear();
    setState(() {
      _minLong = _passCtrler.text.length >= 6 ? true : false;
      _maxLong = _passCtrler.text.length <= 32 ? true : false;
      _hasLow = _passCtrler.text.contains(RegExp(r'[a-z]')) ? true : false;
      _hasUpp = _passCtrler.text.contains(RegExp(r'[A-Z]')) ? true : false;
      _hasNum = _passCtrler.text.contains(RegExp(r'[0-9]')) ? true : false;
      _special = _passCtrler.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))
          ? true
          : false;
      _valid = _minLong & _maxLong & _hasUpp & _hasLow & _hasNum & _special;
    });
  }

  _checkConfirmPassword() {
    setState(() {
      _equals = _valid ? _passCtrler.text == _confirmCtrler.text : false;
    });
  }

  _clear() {
    setState(() {
      _passCtrler.clear();
      _confirmCtrler.clear();
      _valid = false;
    });
  }

  Future _setPassword() async {
    try {
      cripto = Provider.of<CriptoProvider>(context, listen: false);
      bool _setupSuccess = cripto.initialSetup(_passCtrler.text);
      if (_setupSuccess) {
        Navigator.of(context).pushReplacementNamed(ItemsListScreen.routeName);
      }
    } catch (error) {
      throw error;
    }
  }

  @override
  void dispose() {
    _confirmCtrler.dispose();
    _passCtrler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'NOW \nCREATE ONE \nTO \nPROTECT YOUR DATA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                autocorrect: false,
                controller: _passCtrler,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  labelText: 'Password',
                  prefixIcon: _passCtrler.text.isNotEmpty
                      ? InkWell(
                          child: Icon(
                            Icons.visibility,
                          ),
                          onTap: () {
                            setState(() {
                              _obscurePass = !_obscurePass;
                            });
                          },
                        )
                      : null,
                  suffixIcon: _passCtrler.text.isNotEmpty
                      ? InkWell(
                          child: Icon(Icons.clear),
                          onTap: () {
                            _clear();
                            _checkPassword();
                          },
                        )
                      : null,
                ),
                obscureText: _obscurePass,
                onChanged: (_) {
                  _checkPassword();
                },
              ),
              const SizedBox(height: 24),
              TextField(
                autocorrect: false,
                controller: _confirmCtrler,
                enabled: _valid,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  labelText: 'Confirm Password',
                  prefixIcon: _confirmCtrler.text.isNotEmpty
                      ? InkWell(
                          child: Icon(
                            Icons.visibility,
                          ),
                          onTap: () {
                            setState(() {
                              _obscureConfirm = !_obscureConfirm;
                            });
                          },
                        )
                      : null,
                  suffixIcon: _confirmCtrler.text.isNotEmpty
                      ? InkWell(
                          child: Icon(Icons.clear),
                          onTap: () {
                            _confirmCtrler.clear();
                            _checkConfirmPassword();
                          })
                      : null,
                ),
                obscureText: _obscureConfirm,
                onChanged: (_) {
                  _checkConfirmPassword();
                },
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => _setPassword().catchError(
                  (e) => ErrorHelper().errorDialog(context, e),
                ),
              ),
              const SizedBox(height: 24),
              CheckBoard(password: _passCtrler.text),
              const SizedBox(height: 12),
              if (_valid && _equals)
                RaisedButton(
                  onPressed: () => _setPassword().catchError(
                    (e) => ErrorHelper().errorDialog(context, e),
                  ),
                  child: Text('CONTINUE'),
                ),
              const SizedBox(height: 12),
              Text('Not your first time?'),
              const SizedBox(height: 12),
              RaisedButton.icon(
                color: Colors.blue,
                onPressed: () =>
                    Navigator.of(context).pushNamed(RestoreScreen.routeName),
                icon: Icon(Icons.cloud_download, color: Colors.white),
                label: Text(
                  'RESTORE MY DATA',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
