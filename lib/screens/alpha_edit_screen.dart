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
import '../widgets/check_board.dart';
import '../widgets/unlock_container.dart';
import '../widgets/TextFields/ip_text_field.dart';
import '../widgets/TextFields/password_text_field.dart';
import '../widgets/TextFields/pin_text_field.dart';
import '../widgets/TextFields/title_text_field.dart';
import '../widgets/TextFields/username_text_field.dart';
import '../widgets/TextFields/long_text_text_field.dart';
import '../widgets/Cards/alpha_preview_card.dart';
import '../widgets/Cards/user_list_card.dart';
import '../widgets/Cards/password_change_reminder_card.dart';
import '../widgets/Cards/pin_change_reminder_card.dart';

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
  final _longCtrler = TextEditingController();

  FocusNode _userFocusNode;
  FocusNode _passFocusNode;

  bool _username = false;
  bool _password = false;
  bool _pin = false;
  bool _ip = false;
  bool _longText = false;
  bool _passwordRepeatedWarning = true;
  bool _passwordChangeReminder = true;
  bool _pinRepeatedWarning = true;
  bool _pinChangeReminder = true;
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
          _longCtrler.text =
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
        _longCtrler.text.isNotEmpty;
  }

  bool _wasChanged() {
    if (_alpha.title != widget.alpha.title) return true;
    if (_alpha.username != widget.alpha.username) return true;
    if (_alpha.password != widget.alpha.password) return true;
    if (_alpha.passwordLapse != widget.alpha.passwordLapse) return true;
    if (_alpha.passwordStatus != widget.alpha.passwordStatus) return true;
    if (_alpha.pin != widget.alpha.pin) return true;
    if (_alpha.pinLapse != widget.alpha.pinLapse) return true;
    if (_alpha.pinStatus != widget.alpha.pinStatus) return true;
    if (_alpha.ip != widget.alpha.ip) return true;
    if (_alpha.longText != widget.alpha.longText) return true;
    if (_alpha.color != widget.alpha.color) return true;
    if (_alpha.colorLetter != widget.alpha.colorLetter) return true;
    return false;
  }

  void _save() async {
    try {
      DateTime _savingDate = DateTime.now().toUtc();
      _alpha.username = _cripto.doCrypt(_userCtrler.text, _alpha.usernameIV);

      _alpha.passwordHash = _cripto.doHash(_passCtrler.text);

      if (_alpha.passwordHash != widget.alpha.passwordHash) {
        if (_passwordRepeatedWarning) {
          if (await _items.passUsed(_alpha.passwordHash)) {
            bool _warning = false;
            _warning = await WarningHelper.repeatedWarning(context, 'Password');
            if (_warning) {
              _alpha.passwordStatus = 'REPEATED';
            } else {
              return;
            }
          } else {
            _alpha.passwordStatus = '';
          }
        }
        _alpha.password = _cripto.doCrypt(_passCtrler.text, _alpha.passwordIV);
        _alpha.passwordDate = _savingDate.toIso8601String();
      }

      _alpha.pinHash = _cripto.doHash(_pinCtrler.text);

      if (_alpha.pinHash != widget.alpha.pinHash) {
        if (_pinRepeatedWarning) {
          if (await _items.pinUsed(_alpha.pinHash)) {
            bool _warning = false;
            _warning = await WarningHelper.repeatedWarning(context, 'PIN');
            if (_warning) {
              _alpha.pinStatus = 'REPEATED';
            } else {
              return;
            }
          } else {
            _alpha.pinStatus = '';
          }
        }
        _alpha.pin = _cripto.doCrypt(_pinCtrler.text, _alpha.pinIV);
        _alpha.pinDate = _savingDate.toIso8601String();
      }

      _alpha.ip = _cripto.doCrypt(_ipCtrler.text, _alpha.ipIV);
      _alpha.longText = _cripto.doCrypt(_longCtrler.text, _alpha.longTextIV);

      if (_wasChanged())
        _items.updateAlpha(_alpha).then((_) => Navigator.of(context).pop());
      else
        Navigator.of(context).pop();
    } catch (error) {
      ErrorHelper.errorDialog(context, error);
    }
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
      _longCtrler.clear();
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
    _passwordRepeatedWarning = _alpha.passwordStatus != 'NO-WARNING';
    _passwordChangeReminder = _alpha.passwordLapse >= 0;
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
    _longCtrler.dispose();
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
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TitleTextField(_titleCtrler, _refreshScreen),
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
                        if (_passwordChangeReminder)
                          PasswordChangeReminderCard(alpha: _alpha),
                        Card(
                          color: Theme.of(context).backgroundColor,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 3,
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Switch(
                                  activeColor: Colors.green,
                                  value: _passwordRepeatedWarning,
                                  onChanged: (value) => setState(() {
                                    _passwordRepeatedWarning = value;
                                    if (value)
                                      _alpha.passwordStatus = '';
                                    else
                                      _alpha.passwordStatus = 'NO-WARNING';
                                  }),
                                ),
                                Text(
                                  'Password repeated warning',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (_pin)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: PinTextField(_pinCtrler, _refreshScreen),
                    ),
                  if (_pin && _pinCtrler.text.isNotEmpty)
                    Column(
                      children: [
                        if (_pinChangeReminder)
                          PinChangeReminderCard(alpha: _alpha),
                        Card(
                          color: Theme.of(context).backgroundColor,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 3,
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(12),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Switch(
                                  activeColor: Colors.green,
                                  value: _pinRepeatedWarning,
                                  onChanged: (value) => setState(() {
                                    _pinRepeatedWarning = value;
                                    if (value)
                                      _alpha.pinStatus = '';
                                    else
                                      _alpha.pinStatus = 'NO-WARNING';
                                  }),
                                ),
                                Text(
                                  'PIN repeated warning',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
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
                        child: LongTextTextField(_longCtrler),
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
