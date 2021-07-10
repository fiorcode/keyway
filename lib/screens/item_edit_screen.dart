import 'package:flutter/material.dart';
import 'package:keyway/widgets/Cards/address_card.dart';
import 'package:provider/provider.dart';
import 'package:encrypt/encrypt.dart' as e;

import '../providers/cripto_provider.dart';
import '../providers/item_provider.dart';
import '../models/item.dart';
import '../models/username.dart';
import '../models/password.dart';
import '../models/item_password.dart';
import '../models/pin.dart';
import '../models/long_text.dart';
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
  final _addressCtrler = TextEditingController();
  final _protocolCtrler = TextEditingController();
  final _portCtrler = TextEditingController();

  FocusNode _titleFocusNode;
  FocusNode _userFocusNode;
  // FocusNode _passFocusNode;
  // FocusNode _addressFocusNode;
  // FocusNode _protocolFocusNode;
  // FocusNode _portFocusNode;

  bool _passwordRepeatedWarning = true;
  bool _pinRepeatedWarning = true;

  bool _viewUsersList = false;
  bool _unlocking = false;
  bool _loadingRandomPass = false;

  void _refreshScreen() => setState(() {
        _item.title = _titleCtrler.text;
        if (_item.username == null) _userCtrler.clear();
        if (_item.password == null) _passCtrler.clear();
        if (_item.pin == null) _pinCtrler.clear();
        if (_item.longText == null) _longCtrler.clear();
      });

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
        if (widget.item.username != null) {
          _userCtrler.text = _cripto.doDecrypt(
            widget.item.username.usernameEnc,
            widget.item.username.usernameIv,
          );
        }
        if (widget.item.password != null) {
          _passCtrler.text = _cripto.doDecrypt(
            widget.item.password.passwordEnc,
            widget.item.password.passwordIv,
          );
        }
        if (widget.item.pin != null) {
          _pinCtrler.text = _cripto.doDecrypt(
            widget.item.pin.pinEnc,
            widget.item.pin.pinIv,
          );
        }
        if (widget.item.longText != null) {
          _longCtrler.text = _cripto.doDecrypt(
            widget.item.longText.longTextEnc,
            widget.item.longText.longTextIv,
          );
        }
        if (widget.item.address != null) {
          _addressCtrler.text = widget.item.address.addressEnc;
          _protocolCtrler.text = widget.item.address.addressProtocol;
          _portCtrler.text = widget.item.address.addressPort.toString();
        }
      });
    } catch (error) {
      ErrorHelper.errorDialog(context, error);
    }
  }

  // bool _notEmptyFields() {
  //   return _userCtrler.text.isNotEmpty ||
  //       _passCtrler.text.isNotEmpty ||
  //       _pinCtrler.text.isNotEmpty ||
  //       _longCtrler.text.isNotEmpty ||
  //       _addressCtrler.text.isNotEmpty ||
  //       _protocolCtrler.text.isNotEmpty ||
  //       _portCtrler.text.isNotEmpty;
  // }

  void _save() async {
    try {
      DateTime _date = DateTime.now().toUtc();

      if (_userCtrler.text.isNotEmpty) {
        // if (_u != null) {
        //   _item.fkUsernameId = _u.usernameId;
        // } else {
        //   _u = Username();
        //   _u.usernameIv = e.IV.fromSecureRandom(16).base16;
        //   _u.usernameEnc = _cripto.doCrypt(_userCtrler.text, _u.usernameIv);
        //   _item.fkUsernameId = await _items.insertUsername(_u);
        // }
      } else {
        _item.fkUsernameId = null;
        _item.username = null;
      }

      if (_passCtrler.text.isNotEmpty) {
        _item.password.passwordHash = _cripto.doHash(_passCtrler.text);
        if (widget.item.password == null) {
          _item.password = Password();
          _item.itemPassword = ItemPassword();
          if (_passwordRepeatedWarning) {
            if (await _items.passwordInDB(_item.password)) {
              bool _warning = false;
              _warning = await WarningHelper.repeat(context, 'Password');
              if (_warning) {
                Password _p =
                    await _items.getPasswordByHash(_item.password.passwordHash);
                _item.itemPassword.fkPasswordId = _p.passwordId;
                _item.itemPassword.passwordDate = _date.toIso8601String();
                _item.itemPassword.passwordStatus = 'REPEATED';
                _item.itemPassword.fkItemId = _item.itemId;
                await _items.insertItemPassword(_item.itemPassword);
              } else {
                return;
              }
            } else {
              _item.password.passwordIv = e.IV.fromSecureRandom(16).base16;
              _item.password.passwordEnc = _cripto.doCrypt(
                _passCtrler.text,
                _item.password.passwordIv,
              );
              _item.itemPassword.fkPasswordId =
                  await _items.insertPassword(_item.password);
              _item.itemPassword.passwordDate = _date.toIso8601String();
              _item.itemPassword.passwordStatus = '';
              _item.itemPassword.fkItemId = _item.itemId;
              await _items.insertItemPassword(_item.itemPassword);
            }
          }
        } else {
          if (widget.item.password.passwordHash !=
              _item.password.passwordHash) {
            if (_passwordRepeatedWarning) {
              if (await _items.passwordInDB(_item.password)) {
                bool _warning = false;
                _warning = await WarningHelper.repeat(context, 'Password');
                if (_warning) {
                  Password _p = await _items
                      .getPasswordByHash(_item.password.passwordHash);
                  _item.itemPassword.fkPasswordId = _p.passwordId;
                  _item.itemPassword.passwordStatus = 'REPEATED';
                  await _items.insertItemPassword(_item.itemPassword);
                  await _items.refreshItemPasswordStatus(_p.passwordId);
                } else {
                  return;
                }
              } else {
                _item.password = Password();
                _item.password.passwordIv = e.IV.fromSecureRandom(16).base16;
                _item.password.passwordEnc = _cripto.doCrypt(
                  _passCtrler.text,
                  _item.password.passwordIv,
                );

                await _items.insertPassword(_item.password).then((_id) async {
                  _item.itemPassword.fkPasswordId = _id;
                  _item.itemPassword.passwordDate = _date.toIso8601String();
                  _item.itemPassword.passwordStatus = '';
                  _item.itemPassword.fkItemId = _item.itemId;
                  await _items.insertItemPassword(_item.itemPassword);
                });
              }
            }
          } else {
            if (widget.item.itemPassword.passwordLapse !=
                    _item.itemPassword.passwordLapse ||
                widget.item.itemPassword.passwordStatus !=
                    _item.itemPassword.passwordStatus) {
              _items.updateItemPassword(_item.itemPassword);
            }
          }
        }
      }

      if (_pinCtrler.text.isNotEmpty) {
        if (widget.item.pin == null) {
          _item.pin = Pin();
          _item.pin.pinDate = _date.toIso8601String();
          _item.pin.pinIv = e.IV.fromSecureRandom(16).base16;
          _item.pin.pinEnc = _cripto.doCrypt(
            _pinCtrler.text,
            _item.pin.pinIv,
          );
          _item.fkPinId = await _items.insertPin(_item.pin);
        } else {
          _item.pin.pinEnc = _cripto.doCrypt(
            _pinCtrler.text,
            _item.pin.pinIv,
          );
          if (widget.item.pin.pinEnc != _item.pin.pinEnc) {
            _items.updatePin(_item.pin);
          }
        }
      } else {
        _item.fkPinId = null;
        _item.pin = null;
      }

      if (_longCtrler.text.isNotEmpty) {
        if (widget.item.longText == null) {
          _item.longText = LongText();
          _item.longText.longTextIv = e.IV.fromSecureRandom(16).base16;
          _item.longText.longTextEnc = _cripto.doCrypt(
            _longCtrler.text,
            _item.longText.longTextIv,
          );
          _item.fkLongTextId = await _items.insertLongText(_item.longText);
        } else {
          _item.longText.longTextEnc = _cripto.doCrypt(
            _longCtrler.text,
            _item.longText.longTextIv,
          );
          if (widget.item.longText.longTextEnc != _item.longText.longTextEnc) {
            _items.updateLongText(_item.longText);
          }
        }
      } else {
        _item.fkLongTextId = null;
        _item.longText = null;
      }

      if (_item.address != null) {
        if (_addressCtrler.text.isNotEmpty) {
          _item.address.addressEnc = _addressCtrler.text;
          _item.address.addressIv = _addressCtrler.text;
          _item.address.addressProtocol = _protocolCtrler.text;
          _item.address.addressPort = int.parse(_portCtrler.text);
          if (widget.item.address != null) {
            if (widget.item.address.addressEnc != _item.address.addressEnc ||
                widget.item.address.addressProtocol !=
                    _item.address.addressProtocol ||
                widget.item.address.addressPort != _item.address.addressPort) {
              _items.updateAddress(_item.address);
            } else {
              _item.fkAddressId = await _items.insertAddress(_item.address);
            }
          }
        }
      } else {
        _item.fkAddressId = null;
      }

      _items.updateItem(_item).then((_) => Navigator.of(context).pop());
    } catch (error) {
      ErrorHelper.errorDialog(context, error);
    }
  }

  Future<void> _loadRandomPassword() async {
    setState(() => _loadingRandomPass = true);
    PasswordHelper.dicePassword().then((p) {
      setState(() {
        _passCtrler.text = p.passwordEnc;
        _loadingRandomPass = false;
      });
    });
  }

  //TODO: Chequear que se eliminen las notas
  void _delete() async {
    bool _warning = await WarningHelper.deleteItem(context);
    _warning = _warning == null ? false : _warning;
    if (_warning) {
      _item.itemStatus = _item.itemStatus + '<DELETED>';
      _items.updateItem(_item).then((_) => Navigator.of(context).pop());
    }
  }

  @override
  void initState() {
    _cripto = Provider.of<CriptoProvider>(context, listen: false);
    _items = Provider.of<ItemProvider>(context, listen: false);
    _titleFocusNode = FocusNode();
    _userFocusNode = FocusNode();
    // _passFocusNode = FocusNode();
    _item = widget.item.clone();
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
    _addressCtrler.dispose();
    _protocolCtrler.dispose();
    _portCtrler.dispose();
    _userFocusNode.dispose();
    // _passFocusNode.dispose();
    // _protocolFocusNode.dispose();
    // _portFocusNode.dispose();
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
          if (_titleCtrler.text.isNotEmpty && !_cripto.locked)
            IconButton(icon: Icon(Icons.save), onPressed: _save),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TitleTextField(_titleCtrler, _titleFocusNode, _refreshScreen),
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
                                      // _passFocusNode,
                                    ),
                                  ),
                                  _loadingRandomPass
                                      ? CircularProgressIndicator()
                                      : IconButton(
                                          icon: Icon(Icons.bolt),
                                          onPressed: _loadRandomPassword,
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
                          padding: const EdgeInsets.all(8.0),
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
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 192.0,
                            child: LongTextTextField(_longCtrler),
                          ),
                        ),
                      ),
                    ),
                  if (_item.address != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: AddressCard(
                        _addressCtrler,
                        _protocolCtrler,
                        _portCtrler,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TagsCard(item: _item),
                  ),
                  ItemPreviewCard(_item),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      backgroundColor: Colors.red,
                      onPressed: _delete,
                      child: Icon(
                        Icons.delete_forever_rounded,
                        color: Colors.white,
                      ),
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
