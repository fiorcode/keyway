import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cripto_provider.dart';
import '../models/alpha.dart';
import '../widgets/presets_wrap.dart';
import '../widgets/unlock_container.dart';

class AlphaViewScreen extends StatefulWidget {
  static const routeName = '/alpha-view';

  AlphaViewScreen({this.alpha});

  final Alpha alpha;

  @override
  _AlphaViewScreenState createState() => _AlphaViewScreenState();
}

class _AlphaViewScreenState extends State<AlphaViewScreen> {
  CriptoProvider _cripto;
  Alpha _alpha;

  bool _username = false;
  bool _password = false;
  bool _pin = false;
  bool _ip = false;
  bool _longText = false;

  bool _unlocking = false;

  void _lockSwitch() => setState(() => _unlocking = !_unlocking);

  void _load() {
    setState(() {
      _alpha.title = _alpha.title;
      if (_alpha.username.isNotEmpty) {
        _alpha.username = _cripto.doDecrypt(_alpha.username, _alpha.usernameIV);
        _username = true;
      }
      if (_alpha.password.isNotEmpty) {
        _alpha.password = _cripto.doDecrypt(_alpha.password, _alpha.passwordIV);
        _password = true;
      }
      if (_alpha.pin.isNotEmpty) {
        _alpha.pin = _cripto.doDecrypt(_alpha.pin, _alpha.pinIV);
        _pin = true;
      }
      if (_alpha.ip.isNotEmpty) {
        _alpha.ip = _cripto.doDecrypt(_alpha.ip, _alpha.ipIV);
        _ip = true;
      }
      if (_alpha.longText.isNotEmpty) {
        _alpha.longText = _cripto.doDecrypt(_alpha.longText, _alpha.longTextIV);
        _longText = true;
      }
    });
  }

  @override
  void initState() {
    _cripto = Provider.of<CriptoProvider>(context, listen: false);
    _alpha = widget.alpha.clone();
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
                          widget.alpha.title,
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    if (_username) Text('Username'),
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
                                _alpha.username,
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
                                _alpha.password,
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
                                _alpha.pin,
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
                                _alpha.ip,
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
                                _alpha.longText,
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
