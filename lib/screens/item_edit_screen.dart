import 'package:flutter/material.dart';
import 'package:keyway/models/address.dart';
import 'package:keyway/models/item_password.dart';
import 'package:keyway/models/note.dart';
import 'package:keyway/models/pin.dart';
import 'package:keyway/models/product.dart';
import 'package:keyway/widgets/card/password_input_card.dart';
import 'package:provider/provider.dart';

import '../providers/cripto_provider.dart';
import '../providers/item_provider.dart';
import '../models/item.dart';
import '../models/password.dart';
import '../models/username.dart';
import '../helpers/error_helper.dart';
import '../helpers/warning_helper.dart';
import '../widgets/presets_list.dart';
import '../widgets/unlock_container.dart';
import '../widgets/text_field/pin_text_field.dart';
import '../widgets/text_field/title_text_field.dart';
import '../widgets/text_field/username_text_field.dart';
import '../widgets/text_field/long_text_text_field.dart';
import '../widgets/card/item_preview_card.dart';
import '../widgets/card/user_list_card.dart';
import '../widgets/card/pin_change_reminder_card.dart';
import '../widgets/card/tags_card.dart';
import '../widgets/card/address_card.dart';
import '../widgets/card/product_card.dart';

class ItemEditScreen extends StatefulWidget {
  static const routeName = '/edit-item';

  ItemEditScreen({this.item});

  final Item? item;

  @override
  _ItemEditScreenState createState() => _ItemEditScreenState();
}

class _ItemEditScreenState extends State<ItemEditScreen> {
  Item _i = Item();

  TextEditingController _titleCtrler = TextEditingController();
  TextEditingController _userCtrler = TextEditingController();
  TextEditingController _passCtrler = TextEditingController();
  TextEditingController _pinCtrler = TextEditingController();
  TextEditingController _noteCtrler = TextEditingController();
  TextEditingController _addressCtrler = TextEditingController();
  TextEditingController _protocolCtrler = TextEditingController();
  TextEditingController _portCtrler = TextEditingController();
  TextEditingController _trademarkCtrler = TextEditingController();
  TextEditingController _modelCtrler = TextEditingController();

  FocusNode _titleFocusNode = FocusNode();
  FocusNode _userFocusNode = FocusNode();

  bool _viewUsersList = false;
  bool _unlocking = false;

  void _userListSwitch() => setState(() {
        if (_userFocusNode.hasFocus) _userFocusNode.unfocus();
        _viewUsersList = !_viewUsersList;
      });

  void _lockSwitch() => setState(() => _unlocking = !_unlocking);

  void _usernameSwitch() {
    setState(() {
      if (_i.username != null) {
        _userCtrler.clear();
        _i.username = null;
      } else {
        _i.username = Username();
      }
    });
  }

  void _passwordSwitch() {
    setState(() {
      if (_i.password != null) {
        _passCtrler.clear();
        _i.password = null;
        _i.itemPassword = null;
      } else {
        _i.password = Password();
        _i.itemPassword = ItemPassword();
      }
    });
  }

  void _pinSwitch() {
    setState(() {
      if (_i.pin != null) {
        _pinCtrler.clear();
        _i.pin = null;
      } else {
        _i.pin = Pin();
      }
    });
  }

  void _noteSwitch() {
    setState(() {
      if (_i.note != null) {
        _noteCtrler.clear();
        _i.note = null;
      } else {
        _i.note = Note();
      }
    });
  }

  void _addressSwitch() {
    setState(() {
      if (_i.address != null) {
        _addressCtrler.clear();
        _protocolCtrler.clear();
        _portCtrler.clear();
        _i.address = null;
      } else {
        _i.address = Address();
      }
    });
  }

  void _productSwitch() {
    setState(() {
      if (_i.product != null) {
        _trademarkCtrler.clear();
        _modelCtrler.clear();
        _i.product = null;
      } else {
        _i.product = Product();
      }
    });
  }

  void _selectUsername(String username) {
    _userCtrler.text = username;
    _userListSwitch();
  }

  void _loadFieldsAsync() {
    _titleCtrler.text = _i.title;
    if (_i.username != null) _userCtrler.text = _i.username!.usernameDec;
    if (_i.password != null) _passCtrler.text = _i.password!.passwordDec;
    if (_i.pin != null) _pinCtrler.text = _i.pin!.pinDec;
    if (_i.note != null) _noteCtrler.text = _i.note!.noteDec;
    if (_i.address != null) {
      _addressCtrler.text = _i.address!.addressDec;
      _protocolCtrler.text = _i.address!.addressProtocol;
      _portCtrler.text = _i.address!.addressPort.toString();
    }
    if (_i.product != null) {
      _trademarkCtrler.text = _i.product!.productTrademark;
      _modelCtrler.text = _i.product!.productModel;
    }
  }

  Future<void> _setPassword() async {
    ItemProvider _items = Provider.of<ItemProvider>(context, listen: false);
    String _h = CriptoProvider.doHash(_passCtrler.text);
    Password? _p = await _items.passwordInDB(_h);
    if (_p != null) {
      if (_i.itemPassword!.repeatWarning) {
        bool? _warning = await WarningHelper.repeat(context, 'Password');
        _warning = _warning == null ? false : _warning;
        if (!_warning) return;
      }
      _i.password = _p;
    } else {
      CriptoProvider _c = Provider.of<CriptoProvider>(context, listen: false);
      _i.password = await _c.createPassword(_passCtrler.text);
      if (_i.password == null) _i.itemPassword = null;
    }
  }

  void _updateItem() async {
    try {
      ItemProvider _items = Provider.of<ItemProvider>(context, listen: false);
      CriptoProvider _c = Provider.of<CriptoProvider>(context, listen: false);
      if (_i.password != null) {
        _i.password!.passwordHash = CriptoProvider.doHash(_passCtrler.text);
        if (widget.item!.password != null) {
          if (widget.item!.password!.passwordHash !=
              _i.password!.passwordHash) {
            if (_i.password!.passwordHash.isNotEmpty) {
              await _setPassword();
            } else {
              _i.password = null;
            }
          }
        } else {
          if (_i.password!.passwordHash.isNotEmpty) {
            await _setPassword();
          } else {
            _i.password = null;
          }
        }
      }

      if (_i.username != null) {
        String _hash = CriptoProvider.doHash(_userCtrler.text);
        Username? _u = await _items.usernameInDB(_hash);
        if (_u != null) {
          _i.username = _u;
        } else {
          _i.username = await _c.createUsername(_userCtrler.text);
        }
      }

      if (_pinCtrler.text.isNotEmpty) {
        if (widget.item!.pin != null) {
          if (widget.item!.pin!.pinDec != _pinCtrler.text) {
            _i.pin = await _c.createPin(_pinCtrler.text);
          }
        } else {
          _i.pin = await _c.createPin(_pinCtrler.text);
        }
      } else {
        _i.pin = null;
      }

      if (_i.note != null) {
        if (_noteCtrler.text.isNotEmpty) {
          if (widget.item!.note != null) {
            if (widget.item!.note!.noteDec != _noteCtrler.text) {
              _i.note = await _c.createNote(_noteCtrler.text);
            }
          }
        } else {
          _i.note = null;
        }
      }

      if (_i.address != null) {
        if (_addressCtrler.text.isNotEmpty) {
          if (widget.item!.address != null) {
            if (widget.item!.address!.addressDec != _addressCtrler.text) {
              _i.address = await _c.createAddress(_addressCtrler.text);
            }
          }
        } else {
          _i.address = null;
        }
      }

      if (_i.product != null) {
        if (_trademarkCtrler.text.isEmpty && _modelCtrler.text.isEmpty) {
          _i.product = null;
        }
      }

      await _items.updateFullItem(widget.item!, _i);
      await _c.decryptItem(_i);
      Navigator.of(context).pop(_i);
    } catch (error) {
      ErrorHelper.errorDialog(context, error);
    }
  }

  void _updatePreview() => setState(() => _i.title = _titleCtrler.text);

  @override
  void initState() {
    _i = widget.item!.clone();
    _loadFieldsAsync();
    super.initState();
  }

  @override
  void dispose() {
    _titleCtrler.dispose();
    _userCtrler.dispose();
    _passCtrler.dispose();
    _pinCtrler.dispose();
    _noteCtrler.dispose();
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
    CriptoProvider _cripto = Provider.of<CriptoProvider>(context);
    Color _back = Theme.of(context).backgroundColor;
    Color _primary = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: _back,
      appBar: AppBar(
        backgroundColor: _back,
        iconTheme: IconThemeData(color: _primary),
        centerTitle: true,
        title: TitleTextField(_titleCtrler, _titleFocusNode, _updatePreview),
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
                  PresetsList(
                    item: _i,
                    usernameSwitch: _usernameSwitch,
                    passwordSwitch: _passwordSwitch,
                    pinSwitch: _pinSwitch,
                    noteSwitch: _noteSwitch,
                    addressSwitch: _addressSwitch,
                    productSwitch: _productSwitch,
                  ),
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
                      child: PasswordInputCard(_passCtrler, _i),
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
                              PinTextField(_pinCtrler),
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
                                      value: _i.pin!.repeatWarning,
                                      onChanged: (_) {
                                        setState(() {
                                          _i.pin!.repeatWarningSwitch();
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
                            child: LongTextTextField(_noteCtrler),
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
                        _i.product!,
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
