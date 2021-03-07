import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keyway/widgets/tags_listview.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as e;

import '../providers/cripto_provider.dart';
import '../providers/item_provider.dart';
import '../models/alpha.dart';
import '../models/tag.dart';
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

class AlphaScreen extends StatefulWidget {
  static const routeName = '/alpha';

  @override
  _AlphaScreenState createState() => _AlphaScreenState();
}

class _AlphaScreenState extends State<AlphaScreen> {
  CriptoProvider _cripto;
  ItemProvider _items;
  Alpha _alpha;

  final _titleCtrler = TextEditingController();
  final _userCtrler = TextEditingController();
  final _passCtrler = TextEditingController();
  final _pinCtrler = TextEditingController();
  final _ipCtrler = TextEditingController();
  final _longTextCtrler = TextEditingController();

  FocusNode _passFocusNode;
  bool _passFNSwitch = false;

  bool _username = false;
  bool _password = false;
  bool _pin = false;
  bool _ip = false;
  bool _longText = false;

  bool _viewUsersList = false;
  bool _unlocking = false;

  void _ctrlersChanged() => setState(() => _alpha.title = _titleCtrler.text);

  void _userListSwitch() => setState(() => _viewUsersList = !_viewUsersList);

  void _lockSwitch() => setState(() => _unlocking = !_unlocking);

  void _selectUsername(String username) {
    _userCtrler.text = username;
    _userListSwitch();
  }

  void _set() {
    _alpha.usernameHash = _cripto.doHash(_userCtrler.text);
    _alpha.usernameIV = e.IV.fromSecureRandom(16).base16;
    _alpha.username = _cripto.doCrypt(_userCtrler.text, _alpha.usernameIV);

    _alpha.passwordHash = _cripto.doHash(_passCtrler.text);
    _alpha.passwordIV = e.IV.fromSecureRandom(16).base16;
    _alpha.password = _cripto.doCrypt(_passCtrler.text, _alpha.passwordIV);

    _alpha.pinHash = _cripto.doHash(_pinCtrler.text);
    _alpha.pinIV = e.IV.fromSecureRandom(16).base16;
    _alpha.pin = _cripto.doCrypt(_pinCtrler.text, _alpha.pinIV);

    _alpha.ipHash = _cripto.doHash(_ipCtrler.text);
    _alpha.ipIV = e.IV.fromSecureRandom(16).base16;
    _alpha.ip = _cripto.doCrypt(_ipCtrler.text, _alpha.ipIV);

    _alpha.longTextHash = _cripto.doHash(_longTextCtrler.text);
    _alpha.longTextIV = e.IV.fromSecureRandom(16).base16;
    _alpha.longText = _cripto.doCrypt(_longTextCtrler.text, _alpha.longTextIV);
  }

  void _setDate() {
    _alpha.dateTime = DateTime.now().toUtc();
    _alpha.date = _alpha.dateTime.toIso8601String();
    DateFormat dateFormat = DateFormat('dd/MM/yyyy H:mm');
    _alpha.shortDate = dateFormat.format(_alpha.dateTime.toLocal());
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
      _set();
      if (await _checkPassStatus()) return;
      if (await _checkPinStatus()) return;
      _setDate();
      await _items.insert(_alpha);
      Navigator.of(context).pop();
    } catch (error) {
      ErrorHelper.errorDialog(context, error);
    }
  }

  Future<bool> _checkPassStatus() async {
    _alpha.passwordStatus = '';
    if (await _items.isPasswordRepeated(
        sha256.convert(utf8.encode(_passCtrler.text)).toString())) {
      bool _warning = await WarningHelper.repeatedWarning(context, 'Password');
      _warning = _warning == null ? false : _warning;
      if (_warning) {
        _alpha.passwordStatus = 'REPEATED';
        //THIS SHOULD BE AFTER THE INSERT/UPDATE
        _items.setAlphaPassRepeted(_alpha.password);
        _items.setOldAlphaPassRepeted(_alpha.password);
        _items.setDeletedAlphaPassRepeted(_alpha.password);
      } else {
        return true;
      }
    }
    return false;
  }

  Future<bool> _checkPinStatus() async {
    _alpha.pinStatus = '';
    if (await _items.isPinRepeated(
        sha256.convert(utf8.encode(_pinCtrler.text)).toString())) {
      bool _warning = await WarningHelper.repeatedWarning(context, 'PIN');
      _warning = _warning == null ? false : _warning;
      if (_warning) {
        _alpha.pinStatus = 'REPEATED';
        //THIS SHOULD BE AFTER THE INSERT/UPDATE
        _items.setAlphaPinRepeted(_alpha.pin);
        _items.setOldAlphaPinRepeted(_alpha.pin);
        _items.setDeletedAlphaPinRepeted(_alpha.pin);
      } else {
        return true;
      }
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

  void _tagTap(Tag tag) {
    if (_alpha.tags.contains('<${tag.tagName}>')) {
      _alpha.tags = _alpha.tags.replaceAll('<${tag.tagName}>', '');
    } else {
      _alpha.tags += '<${tag.tagName}>';
    }
  }

  @override
  void initState() {
    _passFocusNode = FocusNode();
    _passFocusNode.addListener(() {
      if (_passFocusNode.hasFocus)
        setState(() => _passFNSwitch = true);
      else
        setState(() => _passFNSwitch = false);
    });
    _username = true;
    _password = true;
    _alpha = Alpha(color: Colors.grey.value);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _cripto = Provider.of<CriptoProvider>(context);
    _items = Provider.of<ItemProvider>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _titleCtrler.dispose();
    _userCtrler.dispose();
    _passCtrler.dispose();
    _ipCtrler.dispose();
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
                          _passCtrler, _ctrlersChanged, _passFocusNode),
                    ),
                  if (_passCtrler.text.isNotEmpty &&
                      !PasswordHelper.isStrong(_passCtrler.text) &&
                      _passFNSwitch)
                    CheckBoard(password: _passCtrler.text),
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
                  Text(
                    'Tags:',
                    style: TextStyle(
                      fontSize: 14,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                  TagsListView(tagTap: _tagTap, tags: ''),
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
