import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyway/models/item_password.dart';
import 'package:keyway/providers/cripto_provider.dart';
import 'package:provider/provider.dart';

import '../../helpers/date_helper.dart';
import '../../models/item.dart';

class ItemCleartextCard extends StatefulWidget {
  const ItemCleartextCard({
    Key? key,
    this.item,
    this.buildItem,
    this.deleteItem,
  }) : super(key: key);

  final Item? item;
  final Function? buildItem;
  final Function? deleteItem;

  @override
  _ItemCleartextCardState createState() => _ItemCleartextCardState();
}

class _ItemCleartextCardState extends State<ItemCleartextCard> {
  String? _title;
  late String _subtitle;
  int? _p1n;

  bool _settings = false;
  bool _pin = false;
  bool _setTitle = false;

  TextEditingController? _titleCtrler;
  FocusNode? _titleFN;

  void _settingsSwitch() => setState(() => _settings = !_settings);

  void _toClipBoard() async {
    Clipboard.setData(ClipboardData(text: _title)).then(
      (_) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(_subtitle + ' copied'),
          duration: Duration(seconds: 1),
        ),
      ),
    );
  }

  void _setTitleSwitch() {
    if (_setTitle) {
      _titleCtrler = null;
      _titleFN = null;
    } else {
      _titleCtrler = TextEditingController();
      _titleFN = FocusNode();
      _titleFN!.requestFocus();
    }
    setState(() => _setTitle = !_setTitle);
  }

  void _passwordPin() {
    if (_p1n == null) _p1n = Random.secure().nextInt(9999);
    setState(() {
      _pin = !_pin;
      if (_pin)
        _title = _p1n.toString();
      else {
        _title = widget.item!.title;
      }
    });
  }

  Future<void> _buildItem() async {
    if (_titleCtrler!.text.isEmpty) return;
    Item _i = Item(title: _titleCtrler!.text);
    CriptoProvider _c = Provider.of<CriptoProvider>(context, listen: false);
    if (_pin) {
      _i.pin = await _c.createPin(_p1n.toString());
      widget.buildItem!(widget.item, _i);
    } else {
      _i.password = await _c.createPassword(widget.item!.title!);
      _i.itemPassword = ItemPassword();
      widget.buildItem!(widget.item, _i);
    }
  }

  Future<void>? _delete() => widget.deleteItem!(widget.item);

  @override
  void initState() {
    _title = widget.item!.title;
    _subtitle = 'Created: ' + DateHelper.ddMMyyHm(widget.item!.date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shadowColor: Colors.orange,
      elevation: 8,
      shape: StadiumBorder(),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.all(4),
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: SizedBox(
            height: 48,
            width: 48,
            child: FloatingActionButton(
              heroTag: null,
              backgroundColor: Colors.grey[100],
              child: _setTitle
                  ? Icon(
                      Icons.cancel,
                      color: Colors.red,
                      size: 24,
                    )
                  : Icon(
                      Icons.settings,
                      color: Colors.grey,
                      size: 24,
                    ),
              onPressed: _setTitle ? _setTitleSwitch : _settingsSwitch,
            ),
          ),
        ),
        title: _setTitle
            ? TextField(
                controller: _titleCtrler,
                focusNode: _titleFN,
                decoration: InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                  isDense: true,
                ),
                textCapitalization: TextCapitalization.words,
                style: TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      _title!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  if (_subtitle.isNotEmpty)
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        _subtitle,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                ],
              ),
        onTap: _setTitle ? null : _settingsSwitch,
        trailing: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_settings && !_setTitle)
                SizedBox(
                  height: 48,
                  width: 48,
                  child: FloatingActionButton(
                    backgroundColor: Colors.red,
                    child: Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                      size: 24,
                    ),
                    heroTag: null,
                    onPressed: _delete,
                  ),
                ),
              if (_settings && !_setTitle)
                SizedBox(
                  height: 48,
                  width: 48,
                  child: FloatingActionButton(
                    backgroundColor: Colors.grey[100],
                    child: Icon(
                      _pin ? Icons.password : Icons.pin,
                      color: Colors.grey,
                      size: 24,
                    ),
                    heroTag: null,
                    onPressed: _passwordPin,
                  ),
                ),
              if (_settings && !_setTitle)
                SizedBox(
                  height: 48,
                  width: 48,
                  child: FloatingActionButton(
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.add_circle,
                      color: Colors.white,
                      size: 24,
                    ),
                    heroTag: null,
                    onPressed: _setTitleSwitch,
                  ),
                ),
              if (!_settings && !_setTitle)
                SizedBox(
                  height: 48,
                  width: 48,
                  child: FloatingActionButton(
                    backgroundColor: Colors.grey[100],
                    child: Icon(Icons.copy, color: Colors.grey, size: 24),
                    heroTag: null,
                    onPressed: _toClipBoard,
                  ),
                ),
              if (_setTitle)
                SizedBox(
                  height: 48,
                  width: 48,
                  child: FloatingActionButton(
                    backgroundColor: Colors.grey[100],
                    child: Icon(
                      Icons.done,
                      color: Colors.green,
                      size: 24,
                    ),
                    heroTag: null,
                    onPressed: _buildItem,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
