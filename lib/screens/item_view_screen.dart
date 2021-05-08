import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cripto_provider.dart';
import '../models/item.dart';
import '../helpers/error_helper.dart';
import '../widgets/unlock_container.dart';

class ItemViewScreen extends StatefulWidget {
  static const routeName = '/view-item';

  ItemViewScreen({this.item});

  final Item item;

  @override
  _ItemViewScreenState createState() => _ItemViewScreenState();
}

class _ItemViewScreenState extends State<ItemViewScreen> {
  CriptoProvider _cripto;

  final _titleCtrler = TextEditingController();
  final _userCtrler = TextEditingController();
  final _passCtrler = TextEditingController();
  final _pinCtrler = TextEditingController();
  final _longCtrler = TextEditingController();

  bool _username = false;
  bool _password = false;
  bool _pin = false;
  bool _longText = false;
  bool _unlocking = false;

  void _lockSwitch() => setState(() => _unlocking = !_unlocking);

  void _load() {
    try {
      setState(() {
        _titleCtrler.text = widget.item.title;
        if (widget.item.username != null) {
          _userCtrler.text = _cripto.doDecrypt(
            widget.item.username.usernameEnc,
            widget.item.username.usernameIv,
          );
          _username = true;
        }
        if (widget.item.password != null) {
          _passCtrler.text = _cripto.doDecrypt(
            widget.item.password.passwordEnc,
            widget.item.password.passwordIv,
          );
          _password = true;
        }
        if (widget.item.pin != null) {
          _pinCtrler.text = _cripto.doDecrypt(
            widget.item.pin.pinEnc,
            widget.item.pin.pinIv,
          );
          _pin = true;
        }
        if (widget.item.longText != null) {
          _longCtrler.text = _cripto.doDecrypt(
            widget.item.longText.longTextEnc,
            widget.item.longText.longTextIv,
          );
          _longText = true;
        }
      });
    } catch (error) {
      ErrorHelper.errorDialog(context, error);
    }
  }

  @override
  void initState() {
    _cripto = Provider.of<CriptoProvider>(context, listen: false);
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
                      horizontal: 16,
                      vertical: 32,
                    ),
                    child: TextField(
                      readOnly: true,
                      controller: _titleCtrler,
                      decoration: InputDecoration(
                        border: InputBorder.none,
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
