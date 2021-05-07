import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:encrypt/encrypt.dart' as e;

import '../providers/cripto_provider.dart';
import '../providers/item_provider.dart';
import '../models/item.dart';
import '../models/username.dart';
import '../models/password.dart';
import '../models/item_password.dart';
import '../models/pin.dart';
import '../models/longText.dart';
import '../helpers/error_helper.dart';
import '../helpers/warning_helper.dart';
import '../helpers/password_helper.dart';
import '../widgets/presets_wrap.dart';
import '../widgets/tags_listview.dart';
import '../widgets/check_board.dart';
import '../widgets/unlock_container.dart';
import '../widgets/TextFields/password_text_field.dart';
import '../widgets/TextFields/pin_text_field.dart';
import '../widgets/TextFields/title_text_field.dart';
import '../widgets/TextFields/username_text_field.dart';
import '../widgets/TextFields/long_text_text_field.dart';
import '../widgets/Cards/item_preview_card.dart';
import '../widgets/Cards/user_list_card.dart';
import '../widgets/Cards/password_change_reminder_card.dart';
import '../widgets/Cards/pin_change_reminder_card.dart';

class ItemEditScreen extends StatefulWidget {
  static const routeName = '/edit-item';

  ItemEditScreen({this.item});

  final Item item;

  @override
  _ItemEditScreenState createState() => _ItemEditScreenState();
}

class _ItemEditScreenState extends State<ItemEditScreen> {
  CriptoProvider _cripto;
  ItemProvider _items;

  Item _item;

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

  void _load() {
    try {
      setState(() {
        _titleCtrler.text = widget.item.title;
        if (widget.item.usernameObj != null) {
          _userCtrler.text = _cripto.doDecrypt(
            widget.item.usernameObj.usernameEnc,
            widget.item.usernameObj.usernameIv,
          );
          _username = true;
        }
        if (widget.item.passwordObj != null) {
          _passCtrler.text = _cripto.doDecrypt(
            widget.item.passwordObj.passwordEnc,
            widget.item.passwordObj.passwordIv,
          );
          _password = true;
        }
        if (widget.item.pinObj != null) {
          _pinCtrler.text = _cripto.doDecrypt(
            widget.item.pinObj.pinEnc,
            widget.item.pinObj.pinIv,
          );
          _pin = true;
        }
        if (widget.item.longTextObj != null) {
          _longCtrler.text = _cripto.doDecrypt(
            widget.item.longTextObj.longTextEnc,
            widget.item.longTextObj.longTextIv,
          );
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
        _longCtrler.text.isNotEmpty;
  }

  void _save() async {
    try {
      DateTime _date = DateTime.now().toUtc();

      if (_userCtrler.text.isNotEmpty) {
        if (widget.item.usernameObj == null) {
          _item.usernameObj = Username();
          _item.usernameObj.usernameIv = e.IV.fromSecureRandom(16).base16;
          _item.usernameObj.usernameEnc = _cripto.doCrypt(
            _userCtrler.text,
            _item.usernameObj.usernameIv,
          );
          _item.fkUsernameId = await _items.insertUsername(_item.usernameObj);
        } else {
          _item.usernameObj.usernameEnc = _cripto.doCrypt(
            _userCtrler.text,
            _item.usernameObj.usernameIv,
          );
          if (widget.item.usernameObj.usernameEnc !=
              _item.usernameObj.usernameEnc) {
            _items.updateUsername(_item.usernameObj);
          }
        }
      } else {
        _item.fkUsernameId = null;
        _item.usernameObj = null;
      }

      if (_passCtrler.text.isNotEmpty) {
        _item.passwordObj.hash = _cripto.doHash(_passCtrler.text);
        if (widget.item.passwordObj == null) {
          _item.passwordObj = Password();
          _item.itemPasswordObj = ItemPassword();
          if (_passwordRepeatedWarning) {
            if (await _items.passUsed(_item.passwordObj)) {
              bool _warning = false;
              _warning = await WarningHelper.repeat(context, 'Password');
              if (_warning) {
                Password _p =
                    await _items.getPasswordByHash(_item.passwordObj.hash);
                _item.itemPasswordObj.fkPasswordId = _p.passwordId;
                _item.itemPasswordObj.date = _date.toIso8601String();
                _item.itemPasswordObj.status = 'REPEATED';
                _item.itemPasswordObj.fkItemId = _item.itemId;
                await _items.insertItemPassword(_item.itemPasswordObj);
                // await _items.refreshItemPasswordStatus(_p.passwordId);
              } else {
                return;
              }
            } else {
              _item.passwordObj.passwordIv = e.IV.fromSecureRandom(16).base16;
              _item.passwordObj.passwordEnc = _cripto.doCrypt(
                _passCtrler.text,
                _item.passwordObj.passwordIv,
              );
              _item.itemPasswordObj.fkPasswordId =
                  await _items.insertPassword(_item.passwordObj);
              _item.itemPasswordObj.date = _date.toIso8601String();
              _item.itemPasswordObj.status = '';
              _item.itemPasswordObj.fkItemId = _item.itemId;
              await _items.insertItemPassword(_item.itemPasswordObj);
            }
          }
        } else {
          if (widget.item.passwordObj.hash != _item.passwordObj.hash) {
            if (_passwordRepeatedWarning) {
              if (await _items.passUsed(_item.passwordObj)) {
                bool _warning = false;
                _warning = await WarningHelper.repeat(context, 'Password');
                if (_warning) {
                  Password _p =
                      await _items.getPasswordByHash(_item.passwordObj.hash);
                  _item.itemPasswordObj.fkPasswordId = _p.passwordId;
                  _item.itemPasswordObj.status = 'REPEATED';
                  await _items.insertItemPassword(_item.itemPasswordObj);
                  await _items.refreshItemPasswordStatus(_p.passwordId);
                } else {
                  return;
                }
              } else {
                _item.passwordObj.passwordIv = e.IV.fromSecureRandom(16).base16;
                _item.passwordObj.passwordEnc = _cripto.doCrypt(
                  _passCtrler.text,
                  _item.passwordObj.passwordIv,
                );

                await _items
                    .insertPassword(_item.passwordObj)
                    .then((_id) async {
                  _item.itemPasswordObj.fkPasswordId = _id;
                  _item.itemPasswordObj.date = _date.toIso8601String();
                  _item.itemPasswordObj.status = '';
                  _item.itemPasswordObj.fkItemId = _item.itemId;
                  await _items.insertItemPassword(_item.itemPasswordObj);
                });
              }
            }
          } else {
            if (widget.item.itemPasswordObj.lapse !=
                    _item.itemPasswordObj.lapse ||
                widget.item.itemPasswordObj.status !=
                    _item.itemPasswordObj.status) {
              _items.updateItemPassword(_item.itemPasswordObj);
            }
          }
        }
      }

      if (_pinCtrler.text.isNotEmpty) {
        if (widget.item.pinObj == null) {
          _item.pinObj = Pin();
          _item.pinObj.pinIv = e.IV.fromSecureRandom(16).base16;
          _item.pinObj.pinEnc = _cripto.doCrypt(
            _pinCtrler.text,
            _item.pinObj.pinIv,
          );
          _item.fkPinId = await _items.insertPin(_item.pinObj);
        } else {
          _item.pinObj.pinEnc = _cripto.doCrypt(
            _pinCtrler.text,
            _item.pinObj.pinIv,
          );
          if (widget.item.pinObj.pinEnc != _item.pinObj.pinEnc) {
            _items.updatePin(_item.pinObj);
          }
        }
      } else {
        _item.fkPinId = null;
        _item.pinObj = null;
      }

      if (_longCtrler.text.isNotEmpty) {
        if (widget.item.longTextObj == null) {
          _item.longTextObj = LongText();
          _item.longTextObj.longTextIv = e.IV.fromSecureRandom(16).base16;
          _item.longTextObj.longTextEnc = _cripto.doCrypt(
            _longCtrler.text,
            _item.longTextObj.longTextIv,
          );
          _item.fkLongTextId = await _items.insertLongText(_item.longTextObj);
        } else {
          _item.longTextObj.longTextEnc = _cripto.doCrypt(
            _longCtrler.text,
            _item.longTextObj.longTextIv,
          );
          if (widget.item.longTextObj.longTextEnc !=
              _item.longTextObj.longTextEnc) {
            _items.updateLongText(_item.longTextObj);
          }
        }
      } else {
        _item.fkLongTextId = null;
        _item.longTextObj = null;
      }

      _items.updateItem(_item).then((_) => Navigator.of(context).pop());
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

  void _delete() async {
    _item.status = _item.status + '<DELETED>';
    _items.updateItem(_item).then((_) => Navigator.of(context).pop());
  }

  @override
  void initState() {
    _cripto = Provider.of<CriptoProvider>(context, listen: false);
    _items = Provider.of<ItemProvider>(context, listen: false);
    _userFocusNode = FocusNode();
    _passFocusNode = FocusNode();
    _item = widget.item.clone();
    if (_item.passwordObj != null) {
      _passwordRepeatedWarning = _item.itemPasswordObj.status != 'NO-WARNING';
      _passwordChangeReminder = _item.itemPasswordObj.lapse >= 0;
    }
    _load();
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
    _userFocusNode.dispose();
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
                          PasswordChangeReminderCard(
                              itemPass: _item.itemPasswordObj),
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
                                      _item.itemPasswordObj.status = '';
                                    else
                                      _item.itemPasswordObj.status =
                                          'NO-WARNING';
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
                          PinChangeReminderCard(pin: _item.pinObj),
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
                                      _item.pinObj.pinStatus = '';
                                    else
                                      _item.pinObj.pinStatus = 'NO-WARNING';
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
                  FloatingActionButton(
                    backgroundColor: Colors.red,
                    onPressed: _delete,
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
