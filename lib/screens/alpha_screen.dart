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
import 'package:keyway/widgets/unlock_container.dart';
import 'package:keyway/widgets/Cards/alpha_preview_card.dart';

enum Mode { Create, Edit }

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

  @override
  void initState() {
    super.initState();
    cripto = Provider.of<CriptoProvider>(context, listen: false);
    items = Provider.of<ItemProvider>(context, listen: false);
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
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
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
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Wrap(
                    spacing: 8,
                    children: <Widget>[
                      FloatingActionButton(
                        backgroundColor: _username ? Colors.white : Colors.grey,
                        child: Icon(
                          Icons.account_circle,
                          size: _username ? 32 : 24,
                          color: _username ? Colors.grey : Colors.white,
                        ),
                        heroTag: null,
                        onPressed: () => setState(() {
                          _username = !_username;
                          _userCtrler.clear();
                        }),
                      ),
                      FloatingActionButton(
                        backgroundColor: _password ? Colors.white : Colors.grey,
                        child: Text(
                          '*',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: _password ? 32 : 24,
                            fontWeight: FontWeight.bold,
                            color: _password ? Colors.grey : Colors.white,
                          ),
                        ),
                        heroTag: null,
                        onPressed: () => setState(() {
                          _password = !_password;
                          _passCtrler.clear();
                        }),
                      ),
                      FloatingActionButton(
                        backgroundColor: _pin ? Colors.white : Colors.grey,
                        child: Icon(
                          Icons.dialpad,
                          size: _pin ? 32 : 24,
                          color: _pin ? Colors.grey : Colors.white,
                        ),
                        heroTag: null,
                        onPressed: () => setState(() => _pin = !_pin),
                      ),
                      FloatingActionButton(
                        backgroundColor: _ip ? Colors.white : Colors.grey,
                        child: Icon(
                          Icons.language,
                          size: _ip ? 32 : 24,
                          color: _ip ? Colors.grey : Colors.white,
                        ),
                        heroTag: null,
                        onPressed: () => setState(() => _ip = !_ip),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 64,
                      vertical: 12,
                    ),
                    child: TitleTextField(_titleCtrler, _ctrlersChanged),
                  ),
                  if (_username)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: UsernameTextField(_userCtrler),
                    ),
                  if (_password)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: PasswordTextField(_passCtrler, _ctrlersChanged),
                    ),
                  if (_passCtrler.text.isNotEmpty)
                    CheckBoard(password: _passCtrler.text),
                  if (_pin)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: PinTextField(_pinCtrler),
                    ),
                  if (_ip)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: IpTextField(_ipCtrler),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: AlphaPreviewCard(_item),
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
