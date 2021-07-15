import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cripto_provider.dart';
import '../providers/item_provider.dart';
import '../models/item.dart';
import '../models/username.dart';
import '../models/password.dart';
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
import '../widgets/Cards/product_card.dart';

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
        _item.title = _titleCtrler.text;
        if (_item.username == null) _userCtrler.clear();
        if (_item.password == null) _passCtrler.clear();
        if (_item.pin == null) _pinCtrler.clear();
        if (_item.longText == null) _longCtrler.clear();
        if (_item.address == null) {
          _addressCtrler.clear();
          _protocolCtrler.clear();
          _portCtrler.clear();
        }
        if (_item.product == null) {
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

  void _save() async {
    try {
      Password _p = await _items.passwordInDB(_cripto.doHash(_passCtrler.text));
      if (_p != null) {
        if (_item.itemPassword.repeatWarning) {
          bool _warning = await WarningHelper.repeat(context, 'Password');
          _warning = _warning == null ? false : _warning;
          if (!_warning) return;
        }
        _item.password = _p;
      } else {
        _item.password = _cripto.createPassword(_passCtrler.text);
      }

      Username _u = await _items.usernameInDB(_cripto.doHash(_userCtrler.text));
      if (_u != null) {
        _item.username = _u;
      } else {
        _item.username = _cripto.createUsername(_userCtrler.text);
      }

      _item.pin = _cripto.createPin(_pinCtrler.text);
      _item.longText = _cripto.createLongText(_longCtrler.text);
      _item.address = _cripto.createAddress(_addressCtrler.text);

      _items.insertItem(_item).then((_) => Navigator.of(context).pop());
    } catch (error) {
      ErrorHelper.errorDialog(context, error);
    }
  }

  //TODO: ???
  Future<void> _loadRandomPassword() async {
    setState(() => _loadingRandomPass = true);
    PasswordHelper.dicePassword().then((p) {
      setState(() {
        _passCtrler.text = p.passwordEnc;
        _loadingRandomPass = false;
      });
    });
  }

  @override
  void initState() {
    _cripto = Provider.of<CriptoProvider>(context, listen: false);
    _items = Provider.of<ItemProvider>(context, listen: false);
    _item = Item.factory();
    _titleFocusNode = FocusNode();
    _userFocusNode = FocusNode();
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
                  TitleTextField(_titleCtrler, _titleFocusNode, _updateScreen),
                  PresetsWrap(item: _item, refreshScreen: _updateScreen),
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
                                      value: _item.itemPassword.repeatWarning,
                                      onChanged: (_) {
                                        setState(() {
                                          _item.itemPassword
                                              .repeatWarningSwitch();
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
                              PinTextField(_pinCtrler, _updateScreen),
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
                                      value: _item.pin.repeatWarning,
                                      onChanged: (_) {
                                        setState(() {
                                          _item.pin.repeatWarningSwitch();
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
                  if (_item.address != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: AddressCard(
                        _item.address,
                        _addressCtrler,
                        _protocolCtrler,
                        _portCtrler,
                      ),
                    ),
                  if (_item.product != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ProductCard(
                        _item.product,
                        _trademarkCtrler,
                        _modelCtrler,
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
