import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cripto_provider.dart';
import '../providers/item_provider.dart';
import '../models/alpha.dart';
import '../helpers/error_helper.dart';
import '../helpers/warning_helper.dart';
import '../widgets/unlock_container.dart';

class AlphaViewScreen extends StatefulWidget {
  static const routeName = '/view-alpha';

  AlphaViewScreen({this.alpha});

  final Alpha alpha;

  @override
  _AlphaViewScreenState createState() => _AlphaViewScreenState();
}

class _AlphaViewScreenState extends State<AlphaViewScreen> {
  CriptoProvider _cripto;
  ItemProvider _items;

  final _titleCtrler = TextEditingController();
  final _userCtrler = TextEditingController();
  final _passCtrler = TextEditingController();
  final _pinCtrler = TextEditingController();
  final _ipCtrler = TextEditingController();
  final _longCtrler = TextEditingController();

  bool _username = false;
  bool _password = false;
  bool _pin = false;
  bool _ip = false;
  bool _longText = false;
  bool _unlocking = false;

  void _lockSwitch() => setState(() => _unlocking = !_unlocking);

  void _load() {
    try {
      setState(() {
        _titleCtrler.text = widget.alpha.title;
        if (widget.alpha.username.isNotEmpty) {
          _userCtrler.text =
              _cripto.doDecrypt(widget.alpha.username, widget.alpha.usernameIV);
          _username = true;
        }
        if (widget.alpha.password.isNotEmpty) {
          _passCtrler.text =
              _cripto.doDecrypt(widget.alpha.password, widget.alpha.passwordIV);
          _password = true;
        }
        if (widget.alpha.pin.isNotEmpty) {
          _pinCtrler.text =
              _cripto.doDecrypt(widget.alpha.pin, widget.alpha.pinIV);
          _pin = true;
        }
        if (widget.alpha.ip.isNotEmpty) {
          _ipCtrler.text =
              _cripto.doDecrypt(widget.alpha.ip, widget.alpha.ipIV);
          _ip = true;
        }
        if (widget.alpha.longText.isNotEmpty) {
          _longCtrler.text =
              _cripto.doDecrypt(widget.alpha.longText, widget.alpha.longTextIV);
          _longText = true;
        }
      });
    } catch (error) {
      ErrorHelper.errorDialog(context, error);
    }
  }

  void _delete(BuildContext context) async {
    bool _warning = await WarningHelper.deleteItemWarning(context);
    _warning = _warning == null ? false : _warning;
    if (_warning)
      _items
          .deleteDeletedAlpha(widget.alpha)
          .then((_) => Navigator.of(context).pop());
  }

  @override
  void initState() {
    _cripto = Provider.of<CriptoProvider>(context, listen: false);
    _items = Provider.of<ItemProvider>(context, listen: false);
    _load();
    super.initState();
  }

  @override
  void dispose() {
    _titleCtrler.dispose();
    _userCtrler.dispose();
    _passCtrler.dispose();
    _pinCtrler.dispose();
    _ipCtrler.dispose();
    _longCtrler.dispose();
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
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 32,
                    ),
                    child: TextField(
                      readOnly: true,
                      controller: _titleCtrler,
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: 'Title',
                        hintStyle: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      maxLength: 64,
                      textAlign: TextAlign.center,
                      textCapitalization: TextCapitalization.sentences,
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (_username)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextField(
                        readOnly: true,
                        controller: _userCtrler,
                        autocorrect: false,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).backgroundColor,
                          labelText: 'Username',
                        ),
                        maxLength: 64,
                      ),
                    ),
                  if (_password)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextField(
                        readOnly: true,
                        controller: _passCtrler,
                        autocorrect: false,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).backgroundColor,
                          labelText: 'Password',
                        ),
                      ),
                    ),
                  if (_pin)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: TextField(
                        readOnly: true,
                        controller: _pinCtrler,
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).backgroundColor,
                          hintText: 'PIN',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (_ip)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: TextField(
                        readOnly: true,
                        controller: _ipCtrler,
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).backgroundColor,
                          hintText: '0.0.0.0',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (_longText)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Container(
                        height: 192.0,
                        child: TextField(
                          readOnly: true,
                          controller: _longCtrler,
                          autocorrect: false,
                          keyboardType: TextInputType.multiline,
                          maxLength: 512,
                          maxLines: 32,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1),
                            ),
                            filled: true,
                            fillColor: Theme.of(context).backgroundColor,
                            hintText: 'Note',
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      backgroundColor: Colors.red,
                      onPressed: () => _delete(context),
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
          if (_unlocking && _cripto.locked) UnlockContainer(_lockSwitch),
        ],
      ),
    );
  }
}
