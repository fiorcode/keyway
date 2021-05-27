import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:encrypt/encrypt.dart' as e;

import '../providers/cripto_provider.dart';
import '../providers/item_provider.dart';
import '../models/item.dart';
import '../models/username.dart';
import '../models/longText.dart';
import '../helpers/error_helper.dart';
import '../helpers/warning_helper.dart';
import '../helpers/password_helper.dart';
import '../widgets/presets_wrap.dart';
import '../widgets/unlock_container.dart';
import '../widgets/TextFields/password_text_field.dart';
import '../widgets/TextFields/pin_text_field.dart';
import '../widgets/TextFields/title_text_field.dart';
import '../widgets/TextFields/username_text_field.dart';
import '../widgets/TextFields/long_text_text_field.dart';
import '../widgets/Cards/item_preview_card.dart';
import '../widgets/Cards/user_list_card.dart';
import '../widgets/Cards/strength_level_card.dart';
import '../widgets/Cards/password_change_reminder_card.dart';
import '../widgets/Cards/pin_change_reminder_card.dart';
import '../widgets/Cards/tags_card.dart';

class ItemAddScreen extends StatefulWidget {
  static const routeName = '/add-item';

  @override
  _ItemAddScreenState createState() => _ItemAddScreenState();
}

class _ItemAddScreenState extends State<ItemAddScreen> {
  CriptoProvider _cripto;
  ItemProvider _items;

  Item _item;

  final _titleCtrler = TextEditingController();
  final _userCtrler = TextEditingController();
  final _passCtrler = TextEditingController();
  final _pinCtrler = TextEditingController();
  final _longCtrler = TextEditingController();

  FocusNode _titleFocusNode;
  FocusNode _userFocusNode;
  FocusNode _passFocusNode;

  bool _passwordRepeatedWarning = true;
  bool _pinRepeatedWarning = true;

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

      if (_userCtrler.text.isNotEmpty) {
        Username _u = Username();
        _u.usernameIv = e.IV.fromSecureRandom(16).base16;
        _u.usernameEnc = _cripto.doCrypt(_userCtrler.text, _u.usernameIv);
        _item.fkUsernameId = await _items.insertUsername(_u);
      }

      if (_passCtrler.text.isNotEmpty) {
        _item.password.hash = _cripto.doHash(_passCtrler.text);
        if (_passwordRepeatedWarning) if (await _checkPassStatus()) return;
        _item.password.passwordIv = e.IV.fromSecureRandom(16).base16;
        _item.password.passwordEnc =
            _cripto.doCrypt(_passCtrler.text, _item.password.passwordIv);
        _item.itemPassword.date = _item.date;
        _item.itemPassword.passwordStatus = '';
        _item.itemPassword.fkPasswordId =
            await _items.insertPassword(_item.password);
      }

      if (_pinCtrler.text.isNotEmpty) {
        _item.pin.pinIv = e.IV.fromSecureRandom(16).base16;
        _item.pin.pinEnc = _cripto.doCrypt(_pinCtrler.text, _item.pin.pinIv);
        _item.pin.pinDate = _item.date;
        _item.pin.pinStatus = '';
        _item.fkPinId = await _items.insertPin(_item.pin);
      }

      if (_longCtrler.text.isNotEmpty) {
        LongText _long = LongText();
        _long.longTextIv = e.IV.fromSecureRandom(16).base16;
        _long.longTextEnc = _cripto.doCrypt(_longCtrler.text, _long.longTextIv);
        _item.fkLongTextId = await _items.insertLongText(_long);
      }

      if (_item.device != null) {}

      _items.insertItem(_item).then((itemId) {
        if (_item.password != null) {
          _item.itemPassword.fkItemId = itemId;
          _items
              .insertItemPassword(_item.itemPassword)
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
    if (await _items.passUsed(_item.password)) {
      bool _warning = await WarningHelper.repeat(context, 'Password');
      _warning = _warning == null ? false : _warning;
      if (_warning)
        _item.itemPassword.passwordStatus = 'REPEATED';
      else
        return true;
    }
    return false;
  }

  @override
  void initState() {
    _cripto = Provider.of<CriptoProvider>(context, listen: false);
    _items = Provider.of<ItemProvider>(context, listen: false);
    _titleFocusNode = FocusNode();
    _userFocusNode = FocusNode();
    _passFocusNode = FocusNode();
    _item = Item.factory();
    _titleFocusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    _titleCtrler.dispose();
    _userCtrler.dispose();
    _passCtrler.dispose();
    _pinCtrler.dispose();
    _longCtrler.dispose();
    _userFocusNode.dispose();
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
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TitleTextField(_titleCtrler, _refreshScreen, _titleFocusNode),
                  PresetsWrap(item: _item, refreshScreen: _refreshScreen),
                  if (_item.username != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Card(
                        color: Colors.white,
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (_item.password != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Card(
                        color: Colors.white,
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: PasswordTextField(
                                      _passCtrler,
                                      _refreshScreen,
                                      _passFocusNode,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.bolt),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                              if (_passCtrler.text.isNotEmpty)
                                StrengthLevelCard(
                                  PasswordHelper.strength(
                                    _passCtrler.text,
                                    password: _item.password,
                                  ),
                                ),
                              if (_passCtrler.text.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: PasswordChangeReminderCard(
                                    itemPass: _item.itemPassword,
                                  ),
                                ),
                              if (_passCtrler.text.isNotEmpty)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        'Password repeated warning',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                    Switch(
                                      activeColor: Colors.green,
                                      value: _passwordRepeatedWarning,
                                      onChanged: (value) => setState(() {
                                        _passwordRepeatedWarning = value;
                                        if (value)
                                          _item.itemPassword.passwordStatus =
                                              '';
                                        else
                                          _item.itemPassword.passwordStatus =
                                              'NO-WARNING';
                                      }),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (_item.pin != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Card(
                        color: Colors.white,
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              PinTextField(_pinCtrler, _refreshScreen),
                              if (_pinCtrler.text.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: PinChangeReminderCard(pin: _item.pin),
                                ),
                              if (_pinCtrler.text.isNotEmpty)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        'PIN repeated warning',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                    Switch(
                                      activeColor: Colors.green,
                                      value: _pinRepeatedWarning,
                                      onChanged: (value) => setState(() {
                                        _pinRepeatedWarning = value;
                                        if (value)
                                          _item.pin.pinStatus = '';
                                        else
                                          _item.pin.pinStatus = 'NO-WARNING';
                                      }),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (_item.longText != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Card(
                        color: Colors.white,
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            height: 192.0,
                            child: LongTextTextField(_longCtrler),
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TagsCard(item: _item),
                  ),
                  ItemPreviewCard(_item),
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
