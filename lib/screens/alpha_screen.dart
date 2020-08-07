import 'package:flutter/material.dart';

import 'package:keyway/helpers/drive_helper.dart';
import 'package:keyway/screens/items_screen.dart';
import 'package:keyway/widgets/check_board.dart';
import 'package:provider/provider.dart';

import 'package:keyway/models/item.dart';
import 'package:keyway/providers/cripto_provider.dart';
import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/screens/keyhole_screen.dart';
import 'package:keyway/widgets/TextFields/ip_text_field.dart';
import 'package:keyway/widgets/TextFields/password_text_field.dart';
import 'package:keyway/widgets/TextFields/pin_text_field.dart';
import 'package:keyway/widgets/TextFields/title_text_field.dart';
import 'package:keyway/widgets/TextFields/username_text_field.dart';

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
  final _titleCtrler = TextEditingController();
  final _userCtrler = TextEditingController();
  final _passCtrler = TextEditingController();
  final _pinCtrler = TextEditingController();
  final _ipCtrler = TextEditingController();

  bool _username = false;
  bool _password = false;
  bool _pin = false;
  bool _ip = false;

  final drive = DriveHelper();

  Future<AlphaItem> _createItem() async {
    try {
      return AlphaItem(
        title: _titleCtrler.text,
        username: _userCtrler.text.isEmpty
            ? ''
            : await _cProv.doCrypt(_userCtrler.text),
        password: _passCtrler.text.isEmpty
            ? ''
            : await _cProv.doCrypt(_passCtrler.text),
        pin: _pinCtrler.text.isEmpty
            ? ''
            : await _cProv.doCrypt(_pinCtrler.text),
        ip: _ipCtrler.text.isEmpty ? '' : await _cProv.doCrypt(_ipCtrler.text),
      );
    } catch (error) {
      throw error;
    }
  }

  _loadItem() async {
    try {
      _titleCtrler.text = widget.item.title;
      if (widget.item.username.isNotEmpty) {
        _userCtrler.text = await _cProv.doDecrypt(widget.item.username);
        _username = true;
      }
      if (widget.item.password.isNotEmpty) {
        _passCtrler.text = await _cProv.doDecrypt(widget.item.password);
        _password = true;
      }
      if (widget.item.pin.isNotEmpty) {
        _pinCtrler.text = await _cProv.doDecrypt(widget.item.pin);
        _pin = true;
      }
      if (widget.item.ip.isNotEmpty) {
        _ipCtrler.text = await _cProv.doDecrypt(widget.item.ip);
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
      AlphaItem _item = await _createItem();
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

  _refreshBoard() => setState(() {});

  @override
  void initState() {
    _cProv = Provider.of<CriptoProvider>(context, listen: false);
    _iProv = Provider.of<ItemProvider>(context, listen: false);
    if (widget.item != null)
      _loadItem();
    else {
      _username = true;
      _password = true;
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
                child: TitleTextField(_titleCtrler),
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
