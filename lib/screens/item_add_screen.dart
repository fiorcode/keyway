import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:encrypt/encrypt.dart' as e;

import '../providers/cripto_provider.dart';
import '../providers/item_provider.dart';
import '../models/item.dart';
import 'package:keyway/models/username.dart';
import 'package:keyway/models/item_password.dart';
import 'package:keyway/models/password.dart';
import 'package:keyway/models/pin.dart';
import 'package:keyway/models/longText.dart';
import '../helpers/error_helper.dart';
import '../helpers/warning_helper.dart';
import '../helpers/password_helper.dart';
import '../widgets/presets_wrap.dart';
import '../widgets/check_board.dart';
import '../widgets/unlock_container.dart';
import '../widgets/tags_listview.dart';
import '../widgets/TextFields/password_text_field.dart';
import '../widgets/TextFields/pin_text_field.dart';
import '../widgets/TextFields/title_text_field.dart';
import '../widgets/TextFields/username_text_field.dart';
import '../widgets/TextFields/long_text_text_field.dart';
import '../widgets/Cards/item_preview_card.dart';
import '../widgets/Cards/user_list_card.dart';
import '../widgets/Cards/password_change_reminder_card.dart';
import '../widgets/Cards/pin_change_reminder_card.dart';

class ItemAddScreen extends StatefulWidget {
  static const routeName = '/add-item';

  @override
  _ItemAddScreenState createState() => _ItemAddScreenState();
}

class _ItemAddScreenState extends State<ItemAddScreen> {
  CriptoProvider _cripto;
  ItemProvider _items;

  Item _item;
  ItemPassword _itemPass;
  Password _pass;
  Pin _pinn;

  final _titleCtrler = TextEditingController();
  final _userCtrler = TextEditingController();
  final _passCtrler = TextEditingController();
  final _pinCtrler = TextEditingController();
  final _longCtrler = TextEditingController();

  FocusNode _userFocusNode;
  FocusNode _passFocusNode;

  bool _username = false;
  bool _password = false;
  bool _pin = false;
  bool _device = false;
  bool _longText = false;
  bool _passwordRepeatedWarning = true;
  bool _passwordChangeReminder = true;
  bool _pinRepeatedWarning = true;
  bool _pinChangeReminder = true;
  bool _viewUsersList = false;
  bool _unlocking = false;

  void _refreshScreen() => setState(() => _item.title = _titleCtrler.text);

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
        _longCtrler.text.isNotEmpty;
  }

  void _save() async {
    try {
      _item.date = DateTime.now().toIso8601String();

      if (_username && _userCtrler.text.isNotEmpty) {
        Username _u = Username();
        _u.usernameIv = e.IV.fromSecureRandom(16).base16;
        _u.usernameEnc = _cripto.doCrypt(_userCtrler.text, _u.usernameIv);
        _item.fkUsernameId = await _items.insertUsername(_u);
      }

      if (_password && _passCtrler.text.isNotEmpty) {
        _pass.hash = _cripto.doHash(_passCtrler.text);
        if (_passwordRepeatedWarning) if (await _checkPassStatus()) return;
        _pass.passwordIv = e.IV.fromSecureRandom(16).base16;
        _pass.passwordEnc = _cripto.doCrypt(_passCtrler.text, _pass.passwordIv);
        _itemPass.date = _item.date;
        _itemPass.status = '';
        _pass.strength = '';
        _itemPass.fkPasswordId = await _items.insertPassword(_pass);
      }

      if (_pin && _pinCtrler.text.isNotEmpty) {
        _pinn.pinIv = e.IV.fromSecureRandom(16).base16;
        _pinn.pinEnc = _cripto.doCrypt(_pinCtrler.text, _pinn.pinIv);
        _pinn.pinDate = _item.date;
        _pinn.pinStatus = '';
        _item.fkPinId = await _items.insertPin(_pinn);
      }

      if (_longText && _longCtrler.text.isNotEmpty) {
        LongText _long = LongText();
        _long.longTextIv = e.IV.fromSecureRandom(16).base16;
        _long.longTextEnc = _cripto.doCrypt(_longCtrler.text, _long.longTextIv);
        _item.fkLongTextId = await _items.insertLongText(_long);
      }

      if (_device) {}

      _items.insertItem(_item).then((itemId) {
        if (_password) {
          _itemPass.fkItemId = itemId;
          _items
              .insertItemPassword(_itemPass)
              .then((_) => Navigator.of(context).pop());
        } else {
          Navigator.of(context).pop();
        }
      });
    } catch (error) {
      ErrorHelper.errorDialog(context, error);
    }
  }

  Future<bool> _checkPassStatus() async {
    if (await _items.passUsed(_pass)) {
      bool _warning = await WarningHelper.repeat(context, 'Password');
      _warning = _warning == null ? false : _warning;
      if (_warning)
        _itemPass.status = 'REPEATED';
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

  void _longTextSwitch() {
    setState(() {
      _longCtrler.clear();
      _longText = !_longText;
    });
  }

  void _deviceSwitch() {
    setState(() {
      _device = !_device;
    });
  }

  @override
  void initState() {
    _cripto = Provider.of<CriptoProvider>(context, listen: false);
    _items = Provider.of<ItemProvider>(context, listen: false);
    _userFocusNode = FocusNode();
    _passFocusNode = FocusNode();
    _username = true;
    _password = true;
    _item = Item();
    _pass = Password();
    _itemPass = ItemPassword();
    _pinn = Pin();
    super.initState();
  }

  @override
  void dispose() {
    _titleCtrler.dispose();
    _userCtrler.dispose();
    _passCtrler.dispose();
    _pinCtrler.dispose();
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
                    device: _device,
                    longText: _longText,
                    usernameSwitch: _usernameSwitch,
                    passwordSwitch: _passwordSwitch,
                    pinSwitch: _pinSwitch,
                    deviceSwitch: _deviceSwitch,
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
                          PasswordChangeReminderCard(itemPass: _itemPass),
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
                                  value: _passwordRepeatedWarning,
                                  onChanged: (value) => setState(() {
                                    _passwordRepeatedWarning = value;
                                    if (value)
                                      _itemPass.status = '';
                                    else
                                      _itemPass.status = 'NO-WARNING';
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
                          PinChangeReminderCard(pin: _pinn),
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
                                      _pinn.pinStatus = '';
                                    else
                                      _pinn.pinStatus = 'NO-WARNING';
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
                  // if (_device)
                  //   Padding(
                  //     padding: const EdgeInsets.symmetric(vertical: 12),
                  //     child: IpTextField(_ipCtrler),
                  //   ),
                  if (_longText)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Container(
                        height: 192.0,
                        child: LongTextTextField(_longCtrler),
                      ),
                    ),
                  TagsListView(item: _item),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: ItemPreviewCard(_item),
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
