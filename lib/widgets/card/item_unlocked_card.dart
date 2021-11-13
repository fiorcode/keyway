import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../providers/cripto_provider.dart';
import '../../models/item.dart';

class ItemUnlockedCard extends StatefulWidget {
  const ItemUnlockedCard({Key? key, this.item, this.onTap}) : super(key: key);

  final Item? item;
  final Function? onTap;

  @override
  _ItemUnlockedCardState createState() => _ItemUnlockedCardState();
}

class _ItemUnlockedCardState extends State<ItemUnlockedCard> {
  int _showValue = 0;
  String? _title;
  late String _subtitle;
  bool _repeat = false;
  IconData? _icon;
  Color? _avatarColor;
  Color? _iconColor;
  Color? _warnColor;

  void _onTap() => widget.onTap!();

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

  void _switchView() async {
    CriptoProvider _c = Provider.of<CriptoProvider>(context, listen: false);
    if (_showValue > 6)
      _showValue = 0;
    else
      _showValue++;
    switch (_showValue) {
      case 1:
        if (widget.item!.password == null) continue two;
        _showValue = 1;
        _icon = Icons.password;
        await _c.decryptPassword(widget.item!.password);
        _title = widget.item!.password!.passwordDec;
        _subtitle = '';
        break;
      two:
      case 2:
        if (widget.item!.pin == null) continue three;
        _showValue = 2;
        _icon = Icons.pin;
        await _c.decryptPin(widget.item!.pin);
        _title = widget.item!.pin!.pinDec;
        _subtitle = '';
        break;
      three:
      case 3:
        if (widget.item!.username == null) continue four;
        _showValue = 3;
        _icon = Icons.account_box;
        await _c.decryptUsername(widget.item!.username);
        _title = widget.item!.username!.usernameDec;
        _subtitle = '';
        break;
      four:
      case 4:
        if (widget.item!.note == null) continue five;
        _showValue = 4;
        _icon = Icons.note;
        await _c.decryptNote(widget.item!.note);
        _title = widget.item!.note!.noteDec;
        _subtitle = '';
        break;
      five:
      case 5:
        if (widget.item!.address == null) continue six;
        _showValue = 5;
        _icon = Icons.http;
        await _c.decryptAddress(widget.item!.address);
        _title = widget.item!.address!.addressDec;
        _subtitle =
            'Protocol: ${widget.item!.address!.addressProtocol}, Port: ${widget.item!.address!.addressPort}';
        break;
      six:
      case 6:
        if (widget.item!.product == null) continue cero;
        _showValue = 6;
        _icon = Icons.router;
        _title = '${widget.item!.product!.productTrademark}';
        _subtitle = 'Model: ${widget.item!.product!.productModel}';
        break;
      cero:
      default:
        _showValue = 0;
        _icon = null;
        _title = widget.item!.title;
        _subtitle = '';
    }
    setState(() {});
  }

  bool _repeated() {
    if (widget.item!.itemPassword != null) {
      if (widget.item!.itemPassword!.repeatWarning) {
        return widget.item!.itemPassword!.repeated;
      }
    }
    return false;
  }

  Color _setAvatarColor() {
    if (widget.item!.avatarLetterColor! >= 0)
      return Color(widget.item!.avatarLetterColor!);
    Color _c = Color(widget.item!.avatarColor!);
    double _bgDelta = _c.red * 0.299 + _c.green * 0.587 + _c.blue * 0.114;
    return (255 - _bgDelta > 105) ? Colors.white : Colors.black;
  }

  Color? _setIconColor() {
    if (widget.item!.itemPassword != null) {
      if (widget.item!.itemPassword!.repeatWarning &&
          widget.item!.itemPassword!.repeated) return Colors.grey[200];
    }
    return Colors.grey;
  }

  Color? _setWarningColor() {
    if (widget.item!.itemPassword != null) {
      if (widget.item!.itemPassword!.repeatWarning &&
          widget.item!.itemPassword!.repeated) return Colors.red[300];
    }
    return Colors.grey[100];
  }

  @override
  void initState() {
    _title = widget.item!.title;
    _subtitle = '';
    _repeat = _repeated();
    _avatarColor = _setAvatarColor();
    _iconColor = _setIconColor();
    _warnColor = _setWarningColor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shadowColor: _warnColor,
      elevation: 8,
      shape: StadiumBorder(),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.all(4),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: widget.item!.avatarColor != null
              ? Color(widget.item!.avatarColor!)
              : Colors.grey,
          child: _icon == null
              ? Text(
                  widget.item!.title.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _avatarColor,
                  ),
                )
              : Icon(_icon, color: _avatarColor),
        ),
        title: Column(
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
        onTap: _onTap,
        trailing: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.item!.expired && _showValue == 0)
                SizedBox(
                  height: 48,
                  width: 48,
                  child: Icon(
                    Icons.calendar_today_rounded,
                    color: Colors.red,
                    size: 24,
                  ),
                ),
              if (_repeat && _showValue == 0)
                SizedBox(
                  height: 48,
                  width: 48,
                  child: Icon(
                    Icons.warning,
                    color: Colors.red,
                    size: 24,
                  ),
                ),
              if (_showValue != 0)
                SizedBox(
                  height: 48,
                  width: 48,
                  child: FloatingActionButton(
                    backgroundColor: _warnColor,
                    child: Icon(Icons.copy, color: _iconColor, size: 24),
                    heroTag: null,
                    onPressed: _toClipBoard,
                  ),
                ),
              if (widget.item!.itemStatus!.contains('<password>'))
                SizedBox(
                  height: 48,
                  width: 48,
                  child: FloatingActionButton(
                    backgroundColor: _warnColor,
                    child: Icon(Icons.copy, color: _iconColor, size: 24),
                    heroTag: null,
                    onPressed: _toClipBoard,
                  ),
                ),
              if (!widget.item!.itemStatus!.contains('<password>'))
                SizedBox(width: 4),
              if (!widget.item!.itemStatus!.contains('<password>'))
                SizedBox(
                  height: 48,
                  width: 48,
                  child: InkWell(
                    child: FloatingActionButton(
                      backgroundColor: _warnColor,
                      child: Icon(
                        Icons.remove_red_eye_outlined,
                        color: _iconColor,
                        size: 24,
                      ),
                      heroTag: null,
                      onPressed: _switchView,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
