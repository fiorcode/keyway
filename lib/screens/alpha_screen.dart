import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/item.dart';
import '../providers/cripto_provider.dart';
import '../providers/item_provider.dart';
import '../helpers/error_helper.dart';
import '../helpers/warning_helper.dart';
import '../helpers/password_helper.dart';
import '../screens/items_screen.dart';
import '../widgets/presets_wrap.dart';
import '../widgets/TextFields/ip_text_field.dart';
import '../widgets/TextFields/password_text_field.dart';
import '../widgets/TextFields/pin_text_field.dart';
import '../widgets/TextFields/title_text_field.dart';
import '../widgets/TextFields/username_text_field.dart';
import '../widgets/check_board.dart';
import '../widgets/unlock_container.dart';
import '../widgets/Cards/alpha_preview_card.dart';

enum Mode { Create, Edit }

class AlphaScreen extends StatefulWidget {
  static const routeName = '/alpha';

  AlphaScreen({this.item});

  final Alpha item;

  @override
  _AlphaScreenState createState() => _AlphaScreenState();
}

class _AlphaScreenState extends State<AlphaScreen> {
  CriptoProvider _cripto;
  ItemProvider _items;
  Alpha _item;
  Mode _mode = Mode.Create;

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

  void _ctrlersChanged() => setState(() => _item.title = _titleCtrler.text);

  void _lockSwitch() => setState(() => _unlocking = !_unlocking);

  void _set() {
    _item.username = _cripto.doCrypt(_userCtrler.text);
    _item.password = _cripto.doCrypt(_passCtrler.text);
    _item.pin = _cripto.doCrypt(_pinCtrler.text);
    _item.ip = _cripto.doCrypt(_ipCtrler.text);
    _item.dateTime = DateTime.now().toUtc();
    _item.date = _item.dateTime.toIso8601String();
    DateFormat dateFormat = DateFormat('dd/MM/yyyy H:mm');
    _item.shortDate = dateFormat.format(_item.dateTime.toLocal());
  }

  void _load() {
    _cripto = Provider.of<CriptoProvider>(context, listen: false);
    setState(() {
      _titleCtrler.text = _item.title;
      if (_item.username.isNotEmpty) {
        _userCtrler.text = _cripto.doDecrypt(_item.username);
        _username = true;
      }
      if (_item.password.isNotEmpty) {
        _passCtrler.text = _cripto.doDecrypt(_item.password);
        _password = true;
      }
      if (_item.pin.isNotEmpty) {
        _pinCtrler.text = _cripto.doDecrypt(_item.pin);
        _pin = true;
      }
      if (_item.ip.isNotEmpty) {
        _ipCtrler.text = _cripto.doDecrypt(_item.ip);
        _ip = true;
      }
    });
  }

  bool _notEmptyFields() {
    return _userCtrler.text.isNotEmpty ||
        _passCtrler.text.isNotEmpty ||
        _pinCtrler.text.isNotEmpty ||
        _ipCtrler.text.isNotEmpty;
  }

  bool _filedsChanged() {
    if (_item.title != _titleCtrler.text) return true;
    if (_item.username != _userCtrler.text) return true;
    if (_item.password != _passCtrler.text) return true;
    if (_item.pin != _pinCtrler.text) return true;
    if (_item.ip != _ipCtrler.text) return true;
    if (_item.color != widget.item.color) return true;
    return false;
  }

  void _save() async {
    try {
      _set();
      switch (_mode) {
        case Mode.Create:
          if (await _checkRepeatedPass()) return;
          if (await _checkRepeatedPin()) return;
          await _items.insert(_item);
          break;
        case Mode.Edit:
          if (_passCtrler.text != widget.item.password) {
            if (await _checkRepeatedPass()) return;
          }
          if (_pinCtrler.text != widget.item.pin) {
            if (await _checkRepeatedPin()) return;
          }
          if (_filedsChanged()) {
            await _items.update(_item);
          }
          if (widget.item.repeated == 'y')
            _items.refreshRepetedPassword(widget.item.password);
          break;
        default:
          return;
      }
      Navigator.of(context).pop();
    } catch (error) {
      ErrorHelper.errorDialog(context, error);
    }
  }

  Future<bool> _checkRepeatedPass() async {
    if (_passCtrler.text.isNotEmpty) {
      if (await _items.verifyRepeatedPass(_cripto.doCrypt(_passCtrler.text))) {
        if (await WarningHelper.repeatedWarning(context, 'Password')) {
          _item.repeated = 'y';
          _items.setRepeated('password', _cripto.doCrypt(_passCtrler.text));
        } else
          return true;
      } else
        _item.repeated = 'n';
    }
    return false;
  }

  Future<bool> _checkRepeatedPin() async {
    if (_pinCtrler.text.isNotEmpty) {
      if (await _items.verifyRepeatedPin(_cripto.doCrypt(_pinCtrler.text))) {
        if (await WarningHelper.repeatedWarning(context, 'Pin')) {
          _item.repeated = 'y';
          _items.setRepeated('pin', _cripto.doCrypt(_pinCtrler.text));
        } else
          return true;
      } else
        _item.repeated = 'n';
    }
    return false;
  }

  void usernameSwitch() {
    setState(() {
      _userCtrler.clear();
      _username = !_username;
    });
  }

  void passwordSwitch() {
    setState(() {
      _passCtrler.clear();
      _password = !_password;
    });
  }

  void pinSwitch() {
    setState(() {
      _pinCtrler.clear();
      _pin = !_pin;
    });
  }

  void ipSwitch() {
    setState(() {
      _ipCtrler.clear();
      _ip = !_ip;
    });
  }

  void _delete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete item'),
          content: Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('CANCEL', style: TextStyle(color: Colors.red)),
            ),
            FlatButton(
              onPressed: () => _deleteConfirmed(context),
              child: Text('DELETE', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _deleteConfirmed(BuildContext context) => _items.delete(_item).then(
        (_) => Navigator.of(context)
            .popUntil(ModalRoute.withName(ItemsListScreen.routeName)),
      );

  @override
  void initState() {
    super.initState();
    _cripto = Provider.of<CriptoProvider>(context, listen: false);
    _items = Provider.of<ItemProvider>(context, listen: false);
    if (widget.item != null) {
      _mode = Mode.Edit;
      _item = widget.item;
      _load();
    } else {
      _mode = Mode.Create;
      _username = true;
      _password = true;
      _item = Alpha();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: _cripto.locked
            ? IconButton(
                icon: Icon(
                  Icons.lock_outline,
                  color: _unlocking ? Colors.orange : Colors.red,
                ),
                onPressed: _cripto.locked ? _lockSwitch : null,
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
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PresetsWrap(
                    username: _username,
                    password: _password,
                    pin: _pin,
                    ip: _ip,
                    usernameSwitch: usernameSwitch,
                    passwordSwitch: passwordSwitch,
                    pinSwitch: pinSwitch,
                    ipSwitch: ipSwitch,
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
                      child: UsernameTextField(_userCtrler, _ctrlersChanged),
                    ),
                  if (_password)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: PasswordTextField(_passCtrler, _ctrlersChanged),
                    ),
                  if (_passCtrler.text.isNotEmpty &&
                      !PasswordHelper.isStrong(_passCtrler.text))
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
                      onPressed: () => _delete(context),
                      child: Text(
                        'DELETE',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (_unlocking && _cripto.locked) UnlockContainer(_lockSwitch),
        ],
      ),
    );
  }
}
