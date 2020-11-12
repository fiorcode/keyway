import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:keyway/models/item.dart';
import 'package:keyway/providers/cripto_provider.dart';
import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/helpers/error_helper.dart';
import 'package:keyway/helpers/warning_helper.dart';
import 'package:keyway/screens/items_screen.dart';
import 'package:keyway/widgets/TextFields/ip_text_field.dart';
import 'package:keyway/widgets/TextFields/password_text_field.dart';
import 'package:keyway/widgets/TextFields/pin_text_field.dart';
import 'package:keyway/widgets/TextFields/title_text_field.dart';
import 'package:keyway/widgets/TextFields/username_text_field.dart';
import 'package:keyway/widgets/check_board.dart';
import 'package:keyway/widgets/color_picker.dart';
import 'package:keyway/widgets/unlock_container.dart';
import 'package:keyway/widgets/Cards/alpha_preview_card.dart';

class AlphaScreen extends StatefulWidget {
  static const routeName = '/alpha';

  AlphaScreen({this.item});

  final Alpha item;

  @override
  _AlphaScreenState createState() => _AlphaScreenState();
}

class _AlphaScreenState extends State<AlphaScreen> {
  CriptoProvider cripto;
  ItemProvider items;

  Alpha _item;

  final _titleCtrler = TextEditingController();
  final _userCtrler = TextEditingController();
  final _passCtrler = TextEditingController();
  final _pinCtrler = TextEditingController();
  final _ipCtrler = TextEditingController();

  bool _username = false;
  bool _password = false;
  bool _pin = false;
  bool _ip = false;

  bool _unlocking = false;

  _lockSwitch() {
    setState(() {
      _unlocking = !_unlocking;
    });
  }

  _createItem() {
    try {
      DateFormat dateFormat = DateFormat('dd/MM/yyyy H:mm');
      _item.username =
          _userCtrler.text.isEmpty ? '' : cripto.doCrypt(_userCtrler.text);
      _item.password =
          _passCtrler.text.isEmpty ? '' : cripto.doCrypt(_passCtrler.text);
      _item.pin =
          _pinCtrler.text.isEmpty ? '' : cripto.doCrypt(_pinCtrler.text);
      _item.ip = _ipCtrler.text.isEmpty ? '' : cripto.doCrypt(_ipCtrler.text);
      _item.dateTime = DateTime.now().toUtc();
      _item.date = _item.dateTime.toIso8601String();
      _item.shortDate = dateFormat.format(_item.dateTime.toLocal());
    } catch (error) {
      ErrorHelper.errorDialog(context, error);
    }
  }

  _loadItem() {
    cripto = Provider.of<CriptoProvider>(context, listen: false);
    setState(() {
      _titleCtrler.text = _item.title;
      if (_item.username.isNotEmpty) {
        _userCtrler.text = cripto.doDecrypt(_item.username);
        _username = true;
      }
      if (_item.password.isNotEmpty) {
        _passCtrler.text = cripto.doDecrypt(_item.password);
        _password = true;
      }
      if (_item.pin.isNotEmpty) {
        _pinCtrler.text = cripto.doDecrypt(_item.pin);
        _pin = true;
      }
      if (_item.ip.isNotEmpty) {
        _ipCtrler.text = cripto.doDecrypt(_item.ip);
        _ip = true;
      }
    });
  }

  _save() async {
    try {
      _createItem();
      if (_item.password.isNotEmpty) {
        if (await items.checkPassRepeated(_item.password)) {
          WarningHelper().passRepeatedWarning(context, _saveRepeated);
        } else {
          if (_item.id != null)
            items.update(_item);
          else
            items.insert(_item);
          Navigator.of(context).pop();
        }
      } else {
        if (_item.id != null)
          items.update(_item);
        else
          items.insert(_item);
        Navigator.of(context).pop();
      }
    } catch (error) {
      ErrorHelper.errorDialog(context, error);
    }
  }

  _saveRepeated() {
    if (_item.id != null)
      items.updateRepeated(_item);
    else
      items.insertRepeated(_item);
    Navigator.of(context)
        .popUntil(ModalRoute.withName(ItemsListScreen.routeName));
  }

  _ctrlersChanged() {
    setState(() {
      _item.title = _titleCtrler.text;
    });
  }

  _setColor(int color) {
    setState(() {
      _item.color = color;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (widget.item != null) {
      _item = widget.item;
      _loadItem();
    } else {
      _username = true;
      _password = true;
      _item = Alpha();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    cripto = Provider.of<CriptoProvider>(context, listen: false);
    items = Provider.of<ItemProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: cripto.locked
            ? IconButton(
                icon: Icon(
                  Icons.lock_outline,
                  color: _unlocking ? Colors.orange : Colors.red,
                ),
                onPressed: cripto.locked ? _lockSwitch : null,
              )
            : null,
        actions: [
          if (_titleCtrler.text.isNotEmpty && !cripto.locked)
            IconButton(icon: Icon(Icons.save), onPressed: _save),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 48, vertical: 16),
                    child: TitleTextField(_titleCtrler, _ctrlersChanged),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Wrap(
                      spacing: 8,
                      children: <Widget>[
                        FloatingActionButton(
                          backgroundColor: _username ? null : Colors.grey,
                          child: Icon(Icons.account_circle, size: 32),
                          heroTag: null,
                          onPressed: () => setState(() {
                            _username = !_username;
                            _userCtrler.clear();
                          }),
                        ),
                        FloatingActionButton(
                          backgroundColor: _password ? null : Colors.grey,
                          child: Text(
                            '*',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          heroTag: null,
                          onPressed: () => setState(() {
                            _password = !_password;
                            _passCtrler.clear();
                          }),
                        ),
                        FloatingActionButton(
                          backgroundColor: _pin ? null : Colors.grey,
                          child: Icon(Icons.dialpad, size: 32),
                          heroTag: null,
                          onPressed: () => setState(() => _pin = !_pin),
                        ),
                        FloatingActionButton(
                          backgroundColor: _ip ? null : Colors.grey,
                          child: Icon(Icons.language, size: 32),
                          heroTag: null,
                          onPressed: () => setState(() => _ip = !_ip),
                        ),
                      ],
                    ),
                  ),
                  if (_username)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: UsernameTextField(_userCtrler),
                    ),
                  if (_password)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: PasswordTextField(_passCtrler, _ctrlersChanged),
                    ),
                  if (_passCtrler.text.isNotEmpty)
                    CheckBoard(password: _passCtrler.text),
                  if (_pin)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: PinTextField(_pinCtrler),
                    ),
                  if (_ip)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: IpTextField(_ipCtrler),
                    ),
                  if (_titleCtrler.text.isNotEmpty) AlphaPreviewCard(_item),
                  if (_titleCtrler.text.isNotEmpty) SizedBox(height: 16),
                  if (_titleCtrler.text.isNotEmpty)
                    ColorPicker(_item.color, _setColor),
                  if (widget.item != null)
                    FlatButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Delete item'),
                              content: Text(
                                  'Are you sure you want to delete this item?'),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('CANCEL',
                                      style: TextStyle(color: Colors.red)),
                                ),
                                FlatButton(
                                  onPressed: () async {
                                    items.delete(_item).then(
                                          (_) => Navigator.of(context).popUntil(
                                            ModalRoute.withName(
                                              ItemsListScreen.routeName,
                                            ),
                                          ),
                                        );
                                  },
                                  child: Text('DELETE',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        'DELETE',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (_unlocking && cripto.locked) UnlockContainer(_lockSwitch),
        ],
      ),
    );
  }
}
