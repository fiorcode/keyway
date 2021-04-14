import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'restore_screen.dart';
import 'items_screen.dart';
import '../helpers/password_helper.dart';
import '../helpers/error_helper.dart';
import '../providers/cripto_provider.dart';
import '../widgets/check_board.dart';

class SetPasswordScreen extends StatefulWidget {
  static const routeName = '/set-password';

  @override
  _SetPasswordScreenState createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  CriptoProvider _cripto;
  final _passCtrler = TextEditingController();
  final _confirmCtrler = TextEditingController();

  String _level = '';

  bool _obscurePass = true;
  bool _obscureConfirm = true;

  bool _strong = false;
  bool _equals = false;

  void _checkPassword() => setState(() {
        _level = PasswordHelper.level(_passCtrler.text);
        _strong = PasswordHelper.isStrong(_passCtrler.text);
      });

  _checkConfirmPassword() =>
      setState(() => _equals = _passCtrler.text == _confirmCtrler.text);

  _clear() => setState(() {
        _level = '';
        _confirmCtrler.clear();
        _passCtrler.clear();
        _strong = false;
      });

  _clearConfirm() => setState(() => _confirmCtrler.clear());

  _obscurePassSwitch() => setState(() => _obscurePass = !_obscurePass);

  _obscureConfirmSwitch() => setState(() => _obscureConfirm = !_obscureConfirm);

  _setPassword() async {
    try {
      _cripto = Provider.of<CriptoProvider>(context, listen: false);
      if (await _cripto.initialSetup(_passCtrler.text)) {
        Navigator.of(context).pushReplacementNamed(ItemsListScreen.routeName);
      }
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
      body: Container(
        margin: EdgeInsets.all(32),
        child: ListView(
          children: [
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                'NOW \nCREATE ONE \nTO \nPROTECT YOUR DATA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            SizedBox(height: 48),
            TextField(
              autocorrect: false,
              controller: _passCtrler,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                labelText: 'Password',
                prefixIcon: _passCtrler.text.isNotEmpty
                    ? InkWell(
                        child: Icon(Icons.visibility),
                        onTap: _obscurePassSwitch,
                      )
                    : null,
                suffixIcon: _passCtrler.text.isNotEmpty
                    ? InkWell(
                        child: Icon(Icons.clear),
                        onTap: _clear,
                      )
                    : null,
              ),
              obscureText: _obscurePass,
              onChanged: (_) => _checkPassword(),
            ),
            if (_level != null) Text(_level),
            SizedBox(height: 16),
            if (!_strong && _passCtrler.text.isNotEmpty)
              CheckBoard(password: _passCtrler.text),
            if (_strong) SizedBox(height: 32),
            if (_strong)
              TextField(
                autocorrect: false,
                controller: _confirmCtrler,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  labelText: 'Confirm Password',
                  prefixIcon: _confirmCtrler.text.isNotEmpty
                      ? InkWell(
                          child: Icon(Icons.visibility),
                          onTap: _obscureConfirmSwitch,
                        )
                      : null,
                  suffixIcon: _confirmCtrler.text.isNotEmpty
                      ? _equals
                          ? InkWell(
                              child: Icon(Icons.done),
                              onTap: _setPassword,
                            )
                          : InkWell(
                              child: Icon(Icons.clear),
                              onTap: _clearConfirm,
                            )
                      : null,
                ),
                obscureText: _obscureConfirm,
                onChanged: (_) => _checkConfirmPassword(),
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => _setPassword(),
              ),
            SizedBox(height: 64),
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor),
              onPressed: () =>
                  Navigator.of(context).pushNamed(RestoreScreen.routeName),
              child: Text(
                'RESTORE MY DATA',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
