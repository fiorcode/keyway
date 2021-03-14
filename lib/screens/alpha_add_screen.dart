import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:encrypt/encrypt.dart' as e;

import '../providers/cripto_provider.dart';
import '../providers/item_provider.dart';
import '../models/alpha.dart';
import '../helpers/error_helper.dart';
import '../helpers/warning_helper.dart';
import '../helpers/password_helper.dart';
import '../widgets/presets_wrap.dart';
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
import '../widgets/tags_listview.dart';

class AlphaAddScreen extends StatefulWidget {
  static const routeName = '/add-alpha';

  @override
  _AlphaAddScreenState createState() => _AlphaAddScreenState();
}

class _AlphaAddScreenState extends State<AlphaAddScreen> {
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
  bool _passFNSwitch = false;

  bool _username = false;
  bool _password = false;
  bool _pin = false;
  bool _ip = false;
  bool _longText = false;

  bool _viewUsersList = false;
  bool _unlocking = false;

  double _passLapse = 320;

  void _ctrlersChanged() => setState(() => _alpha.title = _titleCtrler.text);

  void _userListSwitch() => setState(() {
        if (_userFocusNode.hasFocus) _userFocusNode.unfocus();
        _viewUsersList = !_viewUsersList;
      });

  void _lockSwitch() => setState(() => _unlocking = !_unlocking);

  void _selectUsername(String username) {
    _userCtrler.text = username;
    _userListSwitch();
  }

  bool _notEmptyFields() {
    return _userCtrler.text.isNotEmpty ||
        _passCtrler.text.isNotEmpty ||
        _pinCtrler.text.isNotEmpty ||
        _ipCtrler.text.isNotEmpty ||
        _longTextCtrler.text.isNotEmpty;
  }

  void _save() async {
    try {
      _alpha.usernameIV = e.IV.fromSecureRandom(16).base16;
      _alpha.username = _cripto.doCrypt(_userCtrler.text, _alpha.usernameIV);

      _alpha.passwordHash = _cripto.doHash(_passCtrler.text);
      _alpha.passwordIV = e.IV.fromSecureRandom(16).base16;
      _alpha.password = _cripto.doCrypt(_passCtrler.text, _alpha.passwordIV);

      _alpha.pinHash = _cripto.doHash(_pinCtrler.text);
      _alpha.pinIV = e.IV.fromSecureRandom(16).base16;
      _alpha.pin = _cripto.doCrypt(_pinCtrler.text, _alpha.pinIV);

      _alpha.ipIV = e.IV.fromSecureRandom(16).base16;
      _alpha.ip = _cripto.doCrypt(_ipCtrler.text, _alpha.ipIV);

      _alpha.longTextIV = e.IV.fromSecureRandom(16).base16;
      _alpha.longText =
          _cripto.doCrypt(_longTextCtrler.text, _alpha.longTextIV);

      _alpha.dateTime = DateTime.now().toUtc();
      _alpha.date = _alpha.dateTime.toIso8601String();
      DateFormat dateFormat = DateFormat('dd/MM/yyyy H:mm');
      _alpha.shortDate = dateFormat.format(_alpha.dateTime.toLocal());
      if (await _checkPassStatus()) return;
      if (await _checkPinStatus()) return;
      await _items.insertAlpha(_alpha).then((_) => Navigator.of(context).pop());
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

  @override
  void initState() {
    _cripto = Provider.of<CriptoProvider>(context, listen: false);
    _items = Provider.of<ItemProvider>(context, listen: false);
    _userFocusNode = FocusNode();
    _passFocusNode = FocusNode();
    _passFocusNode.addListener(() {
      if (_passFocusNode.hasFocus)
        setState(() => _passFNSwitch = true);
      else
        setState(() => _passFNSwitch = false);
    });
    _username = true;
    _password = true;
    _alpha = Alpha(colorLetter: Colors.white.value);
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
                      vertical: 12,
                    ),
                    child: TitleTextField(_titleCtrler, _ctrlersChanged),
                  ),
                  if (_username)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: UsernameTextField(
                              _userCtrler,
                              _ctrlersChanged,
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
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: PasswordTextField(
                        _passCtrler,
                        _ctrlersChanged,
                        _passFocusNode,
                      ),
                    ),
                  if (_passCtrler.text.isNotEmpty &&
                      !PasswordHelper.isStrong(_passCtrler.text) &&
                      _passFNSwitch)
                    CheckBoard(password: _passCtrler.text),
                  Row(
                    children: [
                      Column(
                        children: [
                          Text('Alert'),
                          Text('change'),
                          Text('in'),
                        ],
                      ),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            valueIndicatorTextStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          child: Slider(
                            min: 0,
                            max: 320,
                            divisions: 10,
                            label: '${_passLapse.round()} days',
                            value: _passLapse,
                            onChanged: (value) {
                              setState(() => _passLapse = value);
                            },
                          ),
                        ),
                      ),
                      // Container(
                      //   width: 64,
                      //   child: Text('${_passLapse.round().toInt()} days'),
                      // ),
                    ],
                  ),
                  if (_pin)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: PinTextField(_pinCtrler),
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
