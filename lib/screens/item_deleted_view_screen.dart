import 'package:flutter/material.dart';
import 'package:keyway/providers/item_provider.dart';
import 'package:provider/provider.dart';

import '../providers/cripto_provider.dart';
import '../models/item.dart';
import '../helpers/error_helper.dart';
import '../widgets/unlock_container.dart';

class ItemDeletedViewScreen extends StatefulWidget {
  static const routeName = '/view-deleted-item';

  ItemDeletedViewScreen({this.item});

  final Item item;

  @override
  _ItemDeletedViewScreenState createState() => _ItemDeletedViewScreenState();
}

class _ItemDeletedViewScreenState extends State<ItemDeletedViewScreen> {
  CriptoProvider _cripto;
  ItemProvider _items;
  bool _unlocking = false;

  final _titleCtrler = TextEditingController();
  TextEditingController _userCtrler;
  TextEditingController _passCtrler;
  TextEditingController _pinCtrler;
  TextEditingController _longCtrler;

  void _lockSwitch() => setState(() => _unlocking = !_unlocking);

  void _load() {
    try {
      setState(() {
        _titleCtrler.text = widget.item.title;
        if (widget.item.username != null) {
          _userCtrler = TextEditingController();
          _userCtrler.text = _cripto.doDecrypt(
            widget.item.username.usernameEnc,
            widget.item.username.usernameIv,
          );
        }
        if (widget.item.password != null) {
          _passCtrler = TextEditingController();
          _passCtrler.text = _cripto.doDecrypt(
            widget.item.password.passwordEnc,
            widget.item.password.passwordIv,
          );
        }
        if (widget.item.pin != null) {
          _pinCtrler = TextEditingController();
          _pinCtrler.text = _cripto.doDecrypt(
            widget.item.pin.pinEnc,
            widget.item.pin.pinIv,
          );
        }
        if (widget.item.longText != null) {
          _longCtrler = TextEditingController();
          _longCtrler.text = _cripto.doDecrypt(
            widget.item.longText.longTextEnc,
            widget.item.longText.longTextIv,
          );
        }
      });
    } catch (error) {
      ErrorHelper.errorDialog(context, error);
    }
  }

  void _restore() async {
    if (widget.item.itemPassword != null) {
      widget.item.unSetDeleted();
      _items
          .updateItem(widget.item, widget.item)
          .then((_) => Navigator.of(context).pop());
    }
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
                  if (widget.item.username != null)
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
                  if (widget.item.password != null)
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
                  if (widget.item.pin != null)
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
                  if (widget.item.longText != null)
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
                  FloatingActionButton(
                    child: Icon(Icons.restore_from_trash),
                    onPressed: _restore,
                  )
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
