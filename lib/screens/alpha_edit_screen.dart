import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cripto_provider.dart';
import '../providers/item_provider.dart';
import '../models/alpha.dart';
import '../helpers/error_helper.dart';
import '../helpers/warning_helper.dart';
import '../helpers/password_helper.dart';
import '../widgets/presets_wrap.dart';
import '../widgets/tags_listview.dart';
import '../widgets/TextFields/ip_text_field.dart';
import '../widgets/TextFields/password_text_field.dart';
import '../widgets/TextFields/pin_text_field.dart';
import '../widgets/TextFields/title_text_field.dart';
import '../widgets/TextFields/username_text_field.dart';
import '../widgets/TextFields/long_text_text_field.dart';
import '../widgets/check_board.dart';
import '../widgets/unlock_container.dart';
import '../widgets/Cards/alpha_preview_card.dart';
import '../widgets/Cards/user_list_card.dart';

class AlphaEditScreen extends StatefulWidget {
  static const routeName = '/edit-alpha';

  AlphaEditScreen({this.alpha});

  final Alpha alpha;

  @override
  _AlphaEditScreenState createState() => _AlphaEditScreenState();
}

class _AlphaEditScreenState extends State<AlphaEditScreen> {
  CriptoProvider _cripto;
  ItemProvider _items;
  Alpha _alpha;

  final _titleCtrler = TextEditingController();
  final _userCtrler = TextEditingController();
  final _passCtrler = TextEditingController();
  final _pinCtrler = TextEditingController();
  final _ipCtrler = TextEditingController();
  final _longTextCtrler = TextEditingController();

  FocusNode _userFocusNode;
  FocusNode _passFocusNode;

  bool _username = false;
  bool _password = false;
  bool _pin = false;
  bool _ip = false;
  bool _longText = false;

  bool _viewUsersList = false;
  bool _unlocking = false;

  void _refreshScreen() => setState(() => _alpha.title = _titleCtrler.text);

  void _userListSwitch() => setState(() {
        if (_userFocusNode.hasFocus) _userFocusNode.unfocus();
        _viewUsersList = !_viewUsersList;
      });

  void _lockSwitch() => setState(() => _unlocking = !_unlocking);

  void _selectUsername(String username) {
    _userCtrler.text = username;
    _userListSwitch();
  }

  void _load() {
    try {
      setState(() {
        _titleCtrler.text = _alpha.title;
        if (_alpha.username.isNotEmpty) {
          _userCtrler.text =
              _cripto.doDecrypt(_alpha.username, _alpha.usernameIV);
          _username = true;
        }
        if (_alpha.password.isNotEmpty) {
          _passCtrler.text =
              _cripto.doDecrypt(_alpha.password, _alpha.passwordIV);
          _password = true;
        }
        if (_alpha.pin.isNotEmpty) {
          _pinCtrler.text = _cripto.doDecrypt(_alpha.pin, _alpha.pinIV);
          _pin = true;
        }
        if (_alpha.ip.isNotEmpty) {
          _ipCtrler.text = _cripto.doDecrypt(_alpha.ip, _alpha.ipIV);
          _ip = true;
        }
        if (_alpha.longText.isNotEmpty) {
          _longTextCtrler.text =
              _cripto.doDecrypt(_alpha.longText, _alpha.longTextIV);
          _longText = true;
        }
      });
    } catch (error) {
      ErrorHelper.errorDialog(context, error);
    }
  }

  bool _notEmptyFields() {
    return _userCtrler.text.isNotEmpty ||
        _passCtrler.text.isNotEmpty ||
        _pinCtrler.text.isNotEmpty ||
        _ipCtrler.text.isNotEmpty ||
        _longTextCtrler.text.isNotEmpty;
  }

  bool _wasChanged() {
    if (_alpha.title != widget.alpha.title) return true;
    if (_alpha.username != widget.alpha.username) return true;
    if (_alpha.password != widget.alpha.password) return true;
    if (_alpha.passwordLapse != widget.alpha.passwordLapse) return true;
    if (_alpha.pin != widget.alpha.pin) return true;
    if (_alpha.pinLapse != widget.alpha.pinLapse) return true;
    if (_alpha.ip != widget.alpha.ip) return true;
    if (_alpha.longText != widget.alpha.longText) return true;
    if (_alpha.color != widget.alpha.color) return true;
    if (_alpha.colorLetter != widget.alpha.colorLetter) return true;
    return false;
  }

  void _save() async {
    try {
      _alpha.username = _cripto.doCrypt(_userCtrler.text, _alpha.usernameIV);

      _alpha.passwordHash = _cripto.doHash(_passCtrler.text);
      if (_alpha.passwordHash != widget.alpha.passwordHash) {
        _alpha.password = _cripto.doCrypt(_passCtrler.text, _alpha.passwordIV);
        _alpha.passwordDate = DateTime.now().toUtc().toIso8601String();
        if (await _checkPassStatus()) return;
      }

      _alpha.pinHash = _cripto.doHash(_pinCtrler.text);
      if (_alpha.pinHash != widget.alpha.pinHash) {
        _alpha.pin = _cripto.doCrypt(_pinCtrler.text, _alpha.pinIV);
        _alpha.pinDate = DateTime.now().toUtc().toIso8601String();
        if (await _checkPinStatus()) return;
      }

      _alpha.ip = _cripto.doCrypt(_ipCtrler.text, _alpha.ipIV);
      _alpha.longText =
          _cripto.doCrypt(_longTextCtrler.text, _alpha.longTextIV);

      if (_wasChanged())
        _items.updateAlpha(_alpha).then((_) => Navigator.of(context).pop());
    } catch (error) {
      ErrorHelper.errorDialog(context, error);
    }
  }

  Future<bool> _checkPassStatus() async {
    if (await _items.isPasswordRepeated(_alpha.passwordHash)) {
      bool _warning = await WarningHelper.repeatedWarning(context, 'Password');
      _warning = _warning == null ? false : _warning;
      if (_warning)
        _alpha.passwordStatus = 'REPEATED';
      else
        return true;
    }
    return false;
  }

  Future<bool> _checkPinStatus() async {
    if (await _items.isPinRepeated(_alpha.pinHash)) {
      bool _warning = await WarningHelper.repeatedWarning(context, 'PIN');
      _warning = _warning == null ? false : _warning;
      if (_warning)
        _alpha.pinStatus = 'REPEATED';
      else
        return true;
    }
    return false;
  }

  void _usernameSwitch() {
    setState(() {
      _userCtrler.clear();
      _username = !_username;
    });
  }

  void _passwordSwitch() {
    setState(() {
      _passCtrler.clear();
      _password = !_password;
    });
  }

  void _pinSwitch() {
    setState(() {
      _pinCtrler.clear();
      _pin = !_pin;
    });
  }

  void _ipSwitch() {
    setState(() {
      _ipCtrler.clear();
      _ip = !_ip;
    });
  }

  void _longTextSwitch() {
    setState(() {
      _longTextCtrler.clear();
      _longText = !_longText;
    });
  }

  void _delete(BuildContext context) async {
    bool _warning = await WarningHelper.deleteItemWarning(context);
    _warning = _warning == null ? false : _warning;
    if (_warning)
      _items.deleteAlpha(_alpha).then((_) => Navigator.of(context).pop());
  }

  @override
  void initState() {
    _cripto = Provider.of<CriptoProvider>(context, listen: false);
    _items = Provider.of<ItemProvider>(context, listen: false);
    _userFocusNode = FocusNode();
    _passFocusNode = FocusNode();
    _alpha = widget.alpha.clone();
    _load();
    super.initState();
  }

  @override
  void dispose() {
    _titleCtrler.dispose();
    _userCtrler.dispose();
    _passCtrler.dispose();
    _pinCtrler.dispose();
    _ipCtrler.dispose();
    _longTextCtrler.dispose();
    _passFocusNode.dispose();
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
        actions: [
          if (_titleCtrler.text.isNotEmpty &&
              !_cripto.locked &&
              _notEmptyFields())
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _save,
            ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                    usernameSwitch: _usernameSwitch,
                    passwordSwitch: _passwordSwitch,
                    pinSwitch: _pinSwitch,
                    ipSwitch: _ipSwitch,
                    longTextSwitch: _longTextSwitch,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 64,
                      vertical: 32,
                    ),
                    child: TitleTextField(_titleCtrler, _refreshScreen),
                  ),
                  if (_username)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: UsernameTextField(
                              _userCtrler,
                              _refreshScreen,
                              _userFocusNode,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.list_rounded),
                            onPressed: _userListSwitch,
                          )
                        ],
                      ),
                    ),
                  if (_password)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: PasswordTextField(
                        _passCtrler,
                        _refreshScreen,
                        _passFocusNode,
                      ),
                    ),
                  if (_passCtrler.text.isNotEmpty &&
                      !PasswordHelper.isStrong(_passCtrler.text))
                    CheckBoard(password: _passCtrler.text),
                  if (_passCtrler.text.isNotEmpty)
                    Column(
                      children: [
                        SizedBox(height: 8),
                        Text('Password useful life (days)'),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            valueIndicatorTextStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          child: Slider(
                            min: 0,
                            max: 320,
                            divisions: 10,
                            label: '${_alpha.passwordLapse.round()} days',
                            value: _alpha.passwordLapse.toDouble(),
                            onChanged: (v) => setState(
                                () => _alpha.passwordLapse = v.round()),
                          ),
                        ),
                      ],
                    ),
                  if (_pin)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: PinTextField(_pinCtrler),
                    ),
                  if (_pin)
                    Column(
                      children: [
                        SizedBox(height: 8),
                        Text('Pin useful life (days)'),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            valueIndicatorTextStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          child: Slider(
                            min: 0,
                            max: 320,
                            divisions: 10,
                            label: '${_alpha.pinLapse.round()} days',
                            value: _alpha.pinLapse.toDouble(),
                            onChanged: (v) =>
                                setState(() => _alpha.pinLapse = v.round()),
                          ),
                        ),
                      ],
                    ),
                  if (_ip)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: IpTextField(_ipCtrler),
                    ),
                  if (_longText)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Container(
                        height: 192.0,
                        child: LongTextTextField(_longTextCtrler),
                      ),
                    ),
                  TagsListView(item: _alpha),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: AlphaPreviewCard(_alpha),
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.red,
                    onPressed: () => _delete(context),
                    child: Icon(
                      Icons.delete_forever_rounded,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_viewUsersList && !_cripto.locked)
            UserListCard(_userCtrler, _userListSwitch, _selectUsername),
          if (_unlocking && _cripto.locked) UnlockContainer(_lockSwitch),
        ],
      ),
    );
  }
}
