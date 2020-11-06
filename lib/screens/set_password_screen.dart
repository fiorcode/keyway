import 'package:flutter/material.dart';
import 'package:keyway/helpers/error_helper.dart';
import 'package:keyway/helpers/password_helper.dart';
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

  bool _obscurePass = true;
  bool _obscureConfirm = true;

  bool _strong = false;
  bool _equals = false;

  _checkPassword() {
    _confirmCtrler.clear();
    setState(() {
      _strong = PasswordHelper.isStrong(_passCtrler.text);
    });
  }

  _checkConfirmPassword() {
    setState(() {
      _equals = _strong ? _passCtrler.text == _confirmCtrler.text : false;
    });
  }

  _clear() {
    setState(() {
      _confirmCtrler.clear();
      _passCtrler.clear();
      _strong = false;
    });
  }

  _setPassword() {
    try {
      CriptoProvider cripto =
          Provider.of<CriptoProvider>(context, listen: false);
      if (cripto.initialSetup(_passCtrler.text))
        Navigator.of(context).pushReplacementNamed(ItemsListScreen.routeName);
    } catch (error) {
      ErrorHelper.errorDialog(context, error);
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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'NOW \nCREATE ONE \nTO \nPROTECT YOUR DATA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: TextField(
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
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: TextField(
                  autocorrect: false,
                  controller: _confirmCtrler,
                  enabled: _strong,
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
                    (e) => ErrorHelper.errorDialog(context, e),
                  ),
                ),
              ),
              CheckBoard(password: _passCtrler.text),
              if (_strong && _equals)
                RaisedButton(
                  onPressed: _setPassword,
                  child: Text('CONTINUE'),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'NOT YOUR FIRST TIME?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () => Navigator.of(context)
                        .pushNamed(RestoreScreen.routeName),
                    child: Text(
                      'RESTORE MY DATA',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
