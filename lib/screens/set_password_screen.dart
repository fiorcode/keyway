import 'package:flutter/material.dart';
import 'package:keyway/widgets/check_board.dart';

class SetPasswordScreen extends StatefulWidget {
  static const routeName = 'set-password';

  @override
  _SetPasswordScreenState createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final _passCtrler = TextEditingController();
  final _confirmCtrler = TextEditingController();

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

  void _checkPassword() {
    _confirmCtrler.clear();
    setState(() {
      _minLong = _passCtrler.text.length >= 16 ? true : false;
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

  void _checkConfirmPassword() {
    setState(() {
      _equals = _valid ? _passCtrler.text == _confirmCtrler.text : false;
    });
  }

  void _clear() {
    setState(() {
      _passCtrler.clear();
      _confirmCtrler.clear();
      _valid = false;
    });
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
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'NOW \nCREATE ONE \nTO PROTECT YOUR \nDATA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
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
                          onTap: () => _confirmCtrler.clear(),
                        )
                      : null,
                ),
                obscureText: _obscureConfirm,
                onChanged: (_) {
                  _checkConfirmPassword();
                },
                textInputAction: TextInputAction.next,
                onSubmitted: (_) {},
              ),
              const SizedBox(height: 24),
              CheckBoard(
                hasLow: _hasLow,
                hasUpp: _hasUpp,
                hasNum: _hasNum,
                special: _special,
                minLong: _minLong,
                maxLong: _maxLong,
              ),
              const SizedBox(height: 24),
              if (_valid && _equals)
                RaisedButton(
                  onPressed: () {},
                  child: Text(
                    'READY',
                    style: TextStyle(color: Colors.green),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
