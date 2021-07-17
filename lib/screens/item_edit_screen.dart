import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:encrypt/encrypt.dart' as e;

import '../providers/cripto_provider.dart';
import '../providers/item_provider.dart';
import '../models/item.dart';
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
import '../widgets/Cards/address_card.dart';

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
  Item _i;

  //TODO: Create when its necesary
  final _titleCtrler = TextEditingController();
  final _userCtrler = TextEditingController();
  final _passCtrler = TextEditingController();
  final _pinCtrler = TextEditingController();
  final _longCtrler = TextEditingController();
  final _addressCtrler = TextEditingController();
  final _protocolCtrler = TextEditingController();
  final _portCtrler = TextEditingController();
  final _trademarkCtrler = TextEditingController();
  final _modelCtrler = TextEditingController();

  FocusNode _titleFocusNode;
  FocusNode _userFocusNode;

  bool _viewUsersList = false;
  bool _unlocking = false;
  bool _loadingRandomPass = false;

  void _updateScreen() => setState(() {
        _i.title = _titleCtrler.text;
        if (_i.username == null) _userCtrler.clear();
        if (_i.password == null) _passCtrler.clear();
        if (_i.pin == null) _pinCtrler.clear();
        if (_i.longText == null) _longCtrler.clear();
        if (_i.address == null) {
          _addressCtrler.clear();
          _protocolCtrler.clear();
          _portCtrler.clear();
        }
        if (_i.product == null) {
          _trademarkCtrler.clear();
          _modelCtrler.clear();
        }
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
      _titleCtrler.text = widget.item.title;
      _userCtrler.text = _cripto.decryptUsername(_i.username);
      _passCtrler.text = _cripto.decryptPassword(_i.password);
      _pinCtrler.text = _cripto.decryptPin(_i.pin);
      _longCtrler.text = _cripto.decryptLongText(_i.longText);
      _addressCtrler.text = _cripto.decryptAddress(_i.address);
      _protocolCtrler.text = _i.address.addressProtocol;
      _portCtrler.text = _i.address.addressProtocol;
      _trademarkCtrler.text = _i.product.productTrademark;
      _modelCtrler.text = _i.product.productModel;
      //setState(() {});
    } catch (error) {
      ErrorHelper.errorDialog(context, error);
    }
  }

  Future<void> _setPassword() async {
    Password _p = await _items.passwordInDB(_cripto.doHash(_passCtrler.text));
    if (_p != null) {
      if (_i.itemPassword.repeatWarning) {
        bool _warning = await WarningHelper.repeat(context, 'Password');
        _warning = _warning == null ? false : _warning;
        if (!_warning) return;
      }
      _i.password = _p;
    } else {
      _i.password = _cripto.createPassword(_passCtrler.text);
      if (_i.password == null) _i.itemPassword = null;
    }
  }

  void _updateItem() async {
    try {
      if (widget.item.password != null) {
        if (_passCtrler.text.isNotEmpty) {
          _i.password.passwordHash = _cripto.doHash(_passCtrler.text);
          if (widget.item.password.passwordHash != _i.password.passwordHash) {
            await _setPassword();
          }
        } else {
          _i.password = null;
        }
      } else {
        if (_passCtrler.text.isNotEmpty) {
          await _setPassword();
        }
      }

      if (_userCtrler.text.isEmpty) _i.username = null;

      if (_pinCtrler.text.isNotEmpty) {
        if (widget.item.pin == null) {
          _i.pin = Pin();
          _i.pin.pinDate = _date.toIso8601String();
          _i.pin.pinIv = e.IV.fromSecureRandom(16).base16;
          _i.pin.pinEnc = _cripto.doCrypt(
            _pinCtrler.text,
            _i.pin.pinIv,
          );
          _i.fkPinId = await _items.insertPin(_i.pin);
        } else {
          _i.pin.pinEnc = _cripto.doCrypt(
            _pinCtrler.text,
            _i.pin.pinIv,
          );
          if (widget.item.pin.pinEnc != _i.pin.pinEnc) {
            _items.updatePin(_i.pin);
          }
        }
      } else {
        _i.fkPinId = null;
        _i.pin = null;
      }

      if (_longCtrler.text.isNotEmpty) {
        if (widget.item.longText == null) {
          _i.longText = LongText();
          _i.longText.longTextIv = e.IV.fromSecureRandom(16).base16;
          _i.longText.longTextEnc = _cripto.doCrypt(
            _longCtrler.text,
            _i.longText.longTextIv,
          );
          _i.fkLongTextId = await _items.insertLongText(_i.longText);
        } else {
          _i.longText.longTextEnc = _cripto.doCrypt(
            _longCtrler.text,
            _i.longText.longTextIv,
          );
          if (widget.item.longText.longTextEnc != _i.longText.longTextEnc) {
            _items.updateLongText(_i.longText);
          }
        }
      } else {
        _i.fkLongTextId = null;
        _i.longText = null;
      }

      if (_i.address != null) {
        if (_addressCtrler.text.isNotEmpty) {
          _i.address.addressEnc = _addressCtrler.text;
          _i.address.addressIv = _addressCtrler.text;
          _i.address.addressProtocol = _protocolCtrler.text;
          _i.address.addressPort = int.parse(_portCtrler.text);
          if (widget.item.address != null) {
            if (widget.item.address.addressEnc != _i.address.addressEnc ||
                widget.item.address.addressProtocol !=
                    _i.address.addressProtocol ||
                widget.item.address.addressPort != _i.address.addressPort) {
              _items.updateAddress(_i.address);
            } else {
              _i.fkAddressId = await _items.insertAddress(_i.address);
            }
          }
        }
      } else {
        _i.fkAddressId = null;
      }

      _items.updateItem(_i).then((_) => Navigator.of(context).pop());
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

  //TODO: Check deletions of all elements of item
  void _delete() async {
    bool _warning = await WarningHelper.deleteItem(context);
    _warning = _warning == null ? false : _warning;
    if (_warning) {
      _i.itemStatus = _i.itemStatus + '<DELETED>';
      _items.updateItem(_i).then((_) => Navigator.of(context).pop());
    }
  }

  @override
  void initState() {
    _cripto = Provider.of<CriptoProvider>(context, listen: false);
    _items = Provider.of<ItemProvider>(context, listen: false);
    _titleFocusNode = FocusNode();
    _userFocusNode = FocusNode();
    _i = widget.item.clone();
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
    _trademarkCtrler.dispose();
    _modelCtrler.dispose();
    _protocolCtrler.dispose();
    _portCtrler.dispose();
    _titleFocusNode.dispose();
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
          if (_titleCtrler.text.isNotEmpty && !_cripto.locked)
            IconButton(icon: Icon(Icons.save), onPressed: _updateItem),
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
                  TitleTextField(_titleCtrler, _titleFocusNode, _updateScreen),
                  PresetsWrap(item: _i, refreshScreen: _updateScreen),
                  if (_i.username != null)
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
                                  _updateScreen,
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
                  if (_i.password != null)
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
                                      _updateScreen,
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
                                    password: _i.password,
                                  ),
                                ),
                              if (_passCtrler.text.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: PasswordChangeReminderCard(
                                    itemPass: _i.itemPassword,
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
                                          _i.itemPassword.passwordStatus = '';
                                        else
                                          _i.itemPassword.passwordStatus =
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
                  if (_i.pin != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Card(
                        color: Colors.white,
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              PinTextField(_pinCtrler, _updateScreen),
                              if (_pinCtrler.text.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: PinChangeReminderCard(pin: _i.pin),
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
                                          _i.pin.pinStatus = '';
                                        else
                                          _i.pin.pinStatus = 'NO-WARNING';
                                      }),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (_i.longText != null)
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
                  if (_i.address != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: AddressCard(
                        _i.address,
                        _addressCtrler,
                        _protocolCtrler,
                        _portCtrler,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TagsCard(item: _i),
                  ),
                  ItemPreviewCard(_i),
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
