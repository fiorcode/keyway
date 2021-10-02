import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cripto_provider.dart';
import '../providers/item_provider.dart';
import '../models/item.dart';
import '../models/password.dart';
import '../models/username.dart';
import '../helpers/error_helper.dart';
import '../helpers/warning_helper.dart';
import '../helpers/password_helper.dart';
import '../widgets/presets_list.dart';
import '../widgets/unlock_container.dart';
import '../widgets/text_field/password_text_field.dart';
import '../widgets/text_field/pin_text_field.dart';
import '../widgets/text_field/title_text_field.dart';
import '../widgets/text_field/username_text_field.dart';
import '../widgets/text_field/long_text_text_field.dart';
import '../widgets/card/item_preview_card.dart';
import '../widgets/card/user_list_card.dart';
import '../widgets/card/strength_level_card.dart';
import '../widgets/card/password_change_reminder_card.dart';
import '../widgets/card/pin_change_reminder_card.dart';
import '../widgets/card/tags_card.dart';
import '../widgets/card/address_card.dart';
import '../widgets/card/product_card.dart';

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

  FocusNode _titleFocusNode = FocusNode();
  FocusNode _userFocusNode = FocusNode();

  bool _viewUsersList = false;
  bool _unlocking = false;
  bool _loadingRandomPass = false;

  void _updateScreen() {
    _i.title = _titleCtrler.text;
    if (_i.username == null) _userCtrler.clear();
    if (_i.password == null) _passCtrler.clear();
    if (_i.pin == null) _pinCtrler.clear();
    if (_i.note == null) _longCtrler.clear();
    if (_i.address == null) {
      _addressCtrler.clear();
      _protocolCtrler.clear();
      _portCtrler.clear();
    }
    if (_i.product == null) {
      _trademarkCtrler.clear();
      _modelCtrler.clear();
    }
    setState(() {});
  }

  void _userListSwitch() => setState(() {
        if (_userFocusNode.hasFocus) _userFocusNode.unfocus();
        _viewUsersList = !_viewUsersList;
      });

  void _lockSwitch() => setState(() => _unlocking = !_unlocking);

  void _selectUsername(String username) {
    _userCtrler.text = username;
    _userListSwitch();
  }

  Future<void> _loadFieldsAsync() async {
    _cripto = Provider.of<CriptoProvider>(context, listen: false);
    _titleCtrler.text = _i.title;
    _userCtrler.text = await _cripto.decryptUsername(_i.username);
    _passCtrler.text = await _cripto.decryptPassword(_i.password);
    _pinCtrler.text = await _cripto.decryptPin(_i.pin);
    _longCtrler.text = await _cripto.decryptNote(_i.note);
    if (_i.address != null) {
      _addressCtrler.text = await _cripto.decryptAddress(_i.address);
      _protocolCtrler.text = _i.address.addressProtocol;
      _portCtrler.text = _i.address.addressPort.toString();
    }
    if (_i.product != null) {
      _trademarkCtrler.text = _i.product.productTrademark;
      _modelCtrler.text = _i.product.productModel;
    }
  }

  Future<void> _setPassword() async {
    Password _p =
        await _items.passwordInDB(CriptoProvider.doHash(_passCtrler.text));
    if (_p != null) {
      if (_i.itemPassword.repeatWarning) {
        bool _warning = await WarningHelper.repeat(context, 'Password');
        _warning = _warning == null ? false : _warning;
        if (!_warning) return;
      }
      _i.password = _p;
    } else {
      _i.password = await _cripto.createPassword(_passCtrler.text);
      if (_i.password == null) _i.itemPassword = null;
    }
  }

  Future<void> _setUsername() async {
    Username _u =
        await _items.usernameInDB(CriptoProvider.doHash(_userCtrler.text));
    if (_u != null) {
      _i.username = _u;
    } else {
      _i.username = await _cripto.createUsername(_userCtrler.text);
    }
  }

  void _updateItem() async {
    try {
      _items = Provider.of<ItemProvider>(context, listen: false);
      if (widget.item.password != null) {
        if (_passCtrler.text.isNotEmpty) {
          _i.password.passwordHash = CriptoProvider.doHash(_passCtrler.text);
          if (widget.item.password.passwordHash != _i.password.passwordHash) {
            await _setPassword();
          }
        } else {
          _i.password = null;
        }
      } else {
        if (_passCtrler.text.isNotEmpty) {
          await _setPassword();
        } else {
          _i.password = null;
        }
      }

      await _setUsername();

      if (widget.item.pin != null) {
        if (_pinCtrler.text.isNotEmpty) {
          if (await _cripto.decryptPin(widget.item.pin) != _pinCtrler.text) {
            _i.pin = await _cripto.createPin(_pinCtrler.text);
          }
        } else {
          _i.pin = null;
        }
      } else {
        if (_i.pin != null) {
          _i.pin = await _cripto.createPin(_pinCtrler.text);
        }
      }

      if (widget.item.note != null) {
        if (_longCtrler.text.isNotEmpty) {
          if (await _cripto.decryptNote(widget.item.note) != _longCtrler.text) {
            _i.note = await _cripto.createNote(_longCtrler.text);
          }
        } else {
          _i.note = null;
        }
      } else {
        if (_i.note != null) {
          _i.note = await _cripto.createNote(_longCtrler.text);
        }
      }

      if (widget.item.address != null) {
        if (_addressCtrler.text.isNotEmpty) {
          if (await _cripto.decryptAddress(widget.item.address) !=
              _addressCtrler.text) {
            _i.address = await _cripto.createAddress(_addressCtrler.text);
          }
        } else {
          _i.address = null;
        }
      } else {
        if (_i.address != null) {
          _i.address = await _cripto.createAddress(_addressCtrler.text);
        }
      }

      if (_trademarkCtrler.text.isEmpty && _modelCtrler.text.isEmpty) {
        _i.product = null;
      }

      _items.updateItem(widget.item, _i).then(
            (_) => Navigator.of(context).pop(_i),
          );
    } catch (error) {
      ErrorHelper.errorDialog(context, error);
    }
  }

  Future<void> _loadRandomPassword() async {
    setState(() => _loadingRandomPass = true);
    PasswordHelper.dicePassword().then((p) {
      setState(() {
        _passCtrler.text = p.password;
        _loadingRandomPass = false;
      });
    });
  }

  @override
  void initState() {
    _i = widget.item.clone();
    _loadFieldsAsync();
    // _loadFields = _loadFieldsAsync();
    super.initState();
  }

  @override
  void dispose() {
    _titleCtrler.dispose();
    _userCtrler.clear();
    _userCtrler.dispose();
    _passCtrler.clear();
    _passCtrler.dispose();
    _pinCtrler.clear();
    _pinCtrler.dispose();
    _longCtrler.clear();
    _longCtrler.dispose();
    _addressCtrler.clear();
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
    _cripto = Provider.of<CriptoProvider>(context);
    _items = Provider.of<ItemProvider>(context, listen: false);
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
                  PresetsList(item: _i, updateScreen: _updateScreen),
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
                                  PasswordHelper.evaluate(
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
                                      value: _i.itemPassword.repeatWarning,
                                      onChanged: (_) => setState(() {
                                        _i.itemPassword.repeatWarningSwitch();
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
                                      value: _i.pin.repeatWarning,
                                      onChanged: (_) {
                                        setState(() {
                                          _i.pin.repeatWarningSwitch();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (_i.note != null)
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
                  if (_i.product != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ProductCard(
                        _i.product,
                        _trademarkCtrler,
                        _modelCtrler,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TagsCard(item: _i),
                  ),
                  ItemPreviewCard(_i),
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
