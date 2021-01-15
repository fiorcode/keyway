import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/item.dart';
import '../providers/cripto_provider.dart';
import '../widgets/presets_wrap.dart';
import '../widgets/unlock_container.dart';

class OldAlphaViewScreen extends StatefulWidget {
  static const routeName = '/old-alpha-view';

  OldAlphaViewScreen({this.oldAlpha});

  final OldAlpha oldAlpha;

  @override
  _OldAlphaViewScreenState createState() => _OldAlphaViewScreenState();
}

class _OldAlphaViewScreenState extends State<OldAlphaViewScreen> {
  CriptoProvider _cripto;
  OldAlpha _oldAlpha;

  bool _username = false;
  bool _password = false;
  bool _pin = false;
  bool _ip = false;
  bool _longText = false;

  bool _unlocking = false;

  void _lockSwitch() => setState(() => _unlocking = !_unlocking);

  void _load() {
    if (_oldAlpha.usernameChange.isNotEmpty) {
      _oldAlpha.username = _cripto.doDecrypt(_oldAlpha.username);
      _username = true;
    }
    if (_oldAlpha.passwordChange.isNotEmpty) {
      _oldAlpha.password = _cripto.doDecrypt(_oldAlpha.password);
      _password = true;
    }
    if (_oldAlpha.pinChange.isNotEmpty) {
      _oldAlpha.pin = _cripto.doDecrypt(_oldAlpha.pin);
      _pin = true;
    }
    if (_oldAlpha.ipChange.isNotEmpty) {
      _oldAlpha.ip = _cripto.doDecrypt(_oldAlpha.ip);
      _ip = true;
    }
    if (_oldAlpha.longTextChange.isNotEmpty) {
      _oldAlpha.longText = _cripto.doDecrypt(_oldAlpha.longText);
      _longText = true;
    }
  }

  @override
  void initState() {
    _cripto = Provider.of<CriptoProvider>(context, listen: false);
    _oldAlpha = widget.oldAlpha.clone();
    _load();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _cripto = Provider.of<CriptoProvider>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        centerTitle: true,
        title: _cripto.locked
            ? IconButton(
                icon: Icon(
                  Icons.lock_outline,
                  color: _unlocking ? Colors.orange : Colors.red,
                ),
                // onPressed: _cripto.locked ? _lockSwitch : null,
                onPressed: () => _cripto.unlock('Qwe123!'),
              )
            : null,
        actions: [],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PresetsWrap(
                      username: _username,
                      password: _password,
                      pin: _pin,
                      ip: _ip,
                      longText: _longText,
                      usernameSwitch: null,
                      passwordSwitch: null,
                      pinSwitch: null,
                      ipSwitch: null,
                      longTextSwitch: null,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 64,
                        vertical: 12,
                      ),
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          widget.oldAlpha.title,
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    if (_username) Text('Username'),
                    if (_username) Text(_oldAlpha.usernameChange),
                    if (_username)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _oldAlpha.username,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (_password) Text('Password'),
                    if (_password) Text(_oldAlpha.passwordChange),
                    if (_password)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _oldAlpha.password,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (_pin) Text('Pin'),
                    if (_pin) Text(_oldAlpha.pinChange),
                    if (_pin)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _oldAlpha.pin,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (_ip) Text('IP'),
                    if (_ip) Text(_oldAlpha.ipChange),
                    if (_ip)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _oldAlpha.ip,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (_longText) Text('Long Text'),
                    if (_longText) Text(_oldAlpha.longTextChange),
                    if (_longText)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _oldAlpha.longText,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (_unlocking && _cripto.locked) UnlockContainer(_lockSwitch),
        ],
      ),
    );
  }
}
