import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'restore_screen.dart';
import 'items_screen.dart';
import '../helpers/password_helper.dart';
import '../helpers/error_helper.dart';
import '../providers/cripto_provider.dart';
import '../widgets/card/strength_level_card.dart';

class SetPasswordScreen extends StatefulWidget {
  static const routeName = '/set-password';

  @override
  _SetPasswordScreenState createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  ZxcvbnResult? _zxcvbnResult;

  final _passCtrler = TextEditingController();
  final _confirmCtrler = TextEditingController();

  bool _obscurePass = false;
  bool _obscureConfirm = false;
  bool _loadingRandomPass = false;
  bool _equals = false;

  void _checkPassword() {
    _equals = _passCtrler.text == _confirmCtrler.text;
    _zxcvbnResult = PasswordHelper.evaluate(_passCtrler.text);
    setState(() {});
  }

  void _checkConfirmPassword() {
    setState(() {
      _equals = _passCtrler.text == _confirmCtrler.text;
      if (_equals) FocusScope.of(context).unfocus();
    });
  }

  void _clear() {
    setState(() {
      _zxcvbnResult = ZxcvbnResult();
      _confirmCtrler.clear();
      _passCtrler.clear();
    });
  }

  void _clearConfirm() {
    setState(() => _confirmCtrler.clear());
  }

  void _obscurePassSwitch() {
    setState(() => _obscurePass = !_obscurePass);
  }

  void _obscureConfirmSwitch() {
    setState(() => _obscureConfirm = !_obscureConfirm);
  }

  Future<void> _loadRandomPassword() async {
    setState(() => _loadingRandomPass = true);
    PasswordHelper.dicePassword().then((result) {
      _zxcvbnResult = result;
      _passCtrler.text = result.password!;
      _confirmCtrler.clear();
      _checkConfirmPassword();
      setState(() => _loadingRandomPass = false);
    }).onError((error, st) => ErrorHelper.errorDialog(context, error));
  }

  void _setPassword() async {
    CriptoProvider.initialSetup(_passCtrler.text).then((success) {
      if (success) {
        Provider.of<CriptoProvider>(context, listen: false)
            .unlock(_passCtrler.text);
        Navigator.of(context).pushReplacementNamed(ItemsListScreen.routeName);
      }
    }).onError((error, st) => ErrorHelper.errorDialog(context, error));
  }

  Color _setButtonColor() {
    switch (_zxcvbnResult!.score) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.lightGreen;
      case 4:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _restoreData() =>
      Navigator.of(context).pushNamed(RestoreScreen.routeName);

  @override
  void initState() {
    _zxcvbnResult = ZxcvbnResult();
    super.initState();
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
                // 'NOW \nCREATE ONE \nTO \nPROTECT YOUR DATA',
                'CREÁ UNA \nCONTRASEÑA \nPARA \nPROTEGER TUS DATOS',
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
              enableInteractiveSelection: false,
              controller: _passCtrler,
              inputFormatters: [
                FilteringTextInputFormatter.allow(PasswordHelper.validRegExp),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                // labelText: 'Master password',
                labelText: 'Contraseña maestra',
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
                    : _loadingRandomPass
                        ? null
                        : IconButton(
                            icon: Icon(Icons.bolt),
                            onPressed: _loadRandomPassword,
                          ),
              ),
              obscureText: _obscurePass,
              onChanged: (_) => _checkPassword(),
            ),
            if (_loadingRandomPass) LinearProgressIndicator(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: StrengthLevelCard(_zxcvbnResult!.score),
            ),
            SizedBox(height: 32),
            TextField(
              autocorrect: false,
              controller: _confirmCtrler,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                // labelText: 'Confirm master password',
                labelText: 'Confirme contraseña maestra',
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
            SizedBox(height: 8),
            if (_equals && _passCtrler.text.isNotEmpty)
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: _setButtonColor()),
                onPressed: _setPassword,
                child: Text(
                  'SET PASSWORD',
                  style: TextStyle(
                      color: _zxcvbnResult!.score == 2
                          ? Colors.grey[800]
                          : Colors.white),
                ),
              ),
            SizedBox(height: 24),
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
              onPressed: _restoreData,
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
