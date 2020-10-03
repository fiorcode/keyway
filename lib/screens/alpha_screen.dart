import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:keyway/models/item.dart';
import 'package:keyway/providers/cripto_provider.dart';
import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/screens/keyhole_screen.dart';
import 'package:keyway/screens/items_screen.dart';
import 'package:keyway/widgets/TextFields/ip_text_field.dart';
import 'package:keyway/widgets/TextFields/password_text_field.dart';
import 'package:keyway/widgets/TextFields/pin_text_field.dart';
import 'package:keyway/widgets/TextFields/title_text_field.dart';
import 'package:keyway/widgets/TextFields/username_text_field.dart';
import 'package:keyway/widgets/check_board.dart';
import 'package:keyway/widgets/alpha_card.dart';
import 'package:keyway/widgets/color_picker.dart';

class AlphaScreen extends StatefulWidget {
  static const routeName = '/alpha';

  AlphaScreen({this.item});

  final AlphaItem item;

  @override
  _AlphaScreenState createState() => _AlphaScreenState();
}

class _AlphaScreenState extends State<AlphaScreen> {
  CriptoProvider _cProv;
  ItemProvider _iProv;

  AlphaItem _item;

  final _titleCtrler = TextEditingController();
  final _userCtrler = TextEditingController();
  final _passCtrler = TextEditingController();
  final _pinCtrler = TextEditingController();
  final _ipCtrler = TextEditingController();

  bool _username = false;
  bool _password = false;
  bool _pin = false;
  bool _ip = false;

  _createItem() async {
    try {
      _item.username = _userCtrler.text.isEmpty
          ? ''
          : await _cProv.doCrypt(_userCtrler.text);
      _item.password = _passCtrler.text.isEmpty
          ? ''
          : await _cProv.doCrypt(_passCtrler.text);
      _item.pin =
          _pinCtrler.text.isEmpty ? '' : await _cProv.doCrypt(_pinCtrler.text);
      _item.ip =
          _ipCtrler.text.isEmpty ? '' : await _cProv.doCrypt(_ipCtrler.text);
      _item.date = DateTime.now().toUtc().toIso8601String();
      DateFormat dateFormat = DateFormat('dd/MM/yyyy H:m');
      _item.shortDate = dateFormat.format(DateTime.now().toUtc());
    } catch (error) {
      throw error;
    }
  }

  _loadItem() async {
    try {
      _titleCtrler.text = _item.title;
      if (_item.username.isNotEmpty) {
        _userCtrler.text = await _cProv.doDecrypt(_item.username);
        _username = true;
      }
      if (_item.password.isNotEmpty) {
        _passCtrler.text = await _cProv.doDecrypt(_item.password);
        _password = true;
      }
      if (_item.pin.isNotEmpty) {
        _pinCtrler.text = await _cProv.doDecrypt(_item.pin);
        _pin = true;
      }
      if (_item.ip.isNotEmpty) {
        _ipCtrler.text = await _cProv.doDecrypt(_item.ip);
        _ip = true;
      }
      setState(() {});
    } catch (error) {
      throw error;
    }
  }

  _save() async {
    try {
      if (_titleCtrler.text.isEmpty) return;
      if (!_username && !_password && !_pin && !_ip) return;
      await _createItem();
      _iProv.addAlpha(_item);
    } catch (error) {}
    Navigator.of(context).pop();
  }

  _saveChanges() async {
    try {
      if (_titleCtrler.text.isEmpty) return;
      AlphaItem _item = await _createItem();
      _item.id = widget.item.id;
      _item.date = widget.item.date;
      _iProv.updateAlpha(_item);
    } catch (error) {}
    Navigator.of(context).pop();
  }

  _ctrlersChanged() {
    setState(() {
      _item.title = _titleCtrler.text;
    });
  }

  _refreshBoard() => setState(() {});

  _setColor(int color) {
    setState(() {
      _item.color = color;
    });
  }

  @override
  void initState() {
    _cProv = Provider.of<CriptoProvider>(context, listen: false);
    _iProv = Provider.of<ItemProvider>(context, listen: false);
    if (widget.item != null) {
      _item = widget.item;
      _loadItem();
    } else {
      _username = true;
      _password = true;
      _item = AlphaItem();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.lock_outline),
            onPressed: () {
              try {
                if (_titleCtrler.text.isEmpty) return;
                if (_cProv.locked)
                  Navigator.of(context).pushNamed(KeyholeScreen.routeName);
                else if (widget.item == null)
                  _save();
                else
                  _saveChanges();
              } catch (error) {}
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
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
                      child: Text('***', style: TextStyle(fontSize: 18)),
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
                  child: PasswordTextField(_passCtrler, _refreshBoard),
                ),
              if (_password) CheckBoard(password: _passCtrler.text),
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
              AlphaCard(_item),
              SizedBox(height: 16),
              ColorPicker(_setColor),
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
                              onPressed: () {
                                _iProv.deleteAlpha(widget.item.id);
                                Navigator.of(context).popUntil(
                                  ModalRoute.withName(
                                      ItemsListScreen.routeName),
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
    );
  }
}
