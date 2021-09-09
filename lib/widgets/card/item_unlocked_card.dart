import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../providers/cripto_provider.dart';
import '../../models/item.dart';
import '../../screens/item_view_screen.dart';

class ItemUnlockedCard extends StatefulWidget {
  const ItemUnlockedCard({Key key, this.item, this.onReturn}) : super(key: key);

  final Item item;
  final Function onReturn;

  @override
  _ItemUnlockedCardState createState() => _ItemUnlockedCardState();
}

class _ItemUnlockedCardState extends State<ItemUnlockedCard> {
  CriptoProvider _cripto;

  int _showValue = 0;
  String _title;
  String _subtitle;
  bool _expire = false;
  bool _repeat = false;
  IconData _icon;
  Color _avatarColor;
  Color _iconColor;
  Color _warnColor;

  void _onTap() {
    if (_cripto.locked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please unlock'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemViewScreen(item: widget.item),
      ),
    ).then((_) => widget.onReturn());
  }

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

  void _switchView() {
    _cripto = Provider.of<CriptoProvider>(context, listen: false);
    if (_showValue > 6)
      _showValue = 0;
    else
      _showValue++;
    switch (_showValue) {
      case 1:
        if (widget.item.password == null) continue two;
        _showValue = 1;
        _icon = Icons.password;
        _title = _cripto.decryptPassword(widget.item.password);
        _subtitle = '';
        break;
      two:
      case 2:
        if (widget.item.pin == null) continue three;
        _showValue = 2;
        _icon = Icons.pin;
        _title = _cripto.decryptPin(widget.item.pin);
        _subtitle = '';
        break;
      three:
      case 3:
        if (widget.item.username == null) continue four;
        _showValue = 3;
        _icon = Icons.account_box;
        _title = _cripto.decryptUsername(widget.item.username);
        _subtitle = '';
        break;
      four:
      case 4:
        if (widget.item.note == null) continue five;
        _showValue = 4;
        _icon = Icons.note;
        _title = _cripto.decryptNote(widget.item.note);
        _subtitle = '';
        break;
      five:
      case 5:
        if (widget.item.address == null) continue six;
        _showValue = 5;
        _icon = Icons.http;
        _title = _cripto.decryptAddress(widget.item.address);
        _subtitle =
            'Protocol: ${widget.item.address.addressProtocol}, Port: ${widget.item.address.addressPort}';
        break;
      six:
      case 6:
        if (widget.item.product == null) continue cero;
        _showValue = 6;
        _icon = Icons.router;
        _title = '${widget.item.product.productTrademark}';
        _subtitle = 'Model: ${widget.item.product.productModel}';
        break;
      cero:
      default:
        _showValue = 0;
        _icon = null;
        _title = widget.item.title;
        _subtitle = '';
    }
    setState(() {});
  }

  bool _expired() {
    bool _expired = false;
    if (widget.item.itemPassword != null) {
      _expired = widget.item.itemPassword.expired;
      if (_expired) return true;
    }
    if (widget.item.pin != null) {
      _expired = widget.item.pin.expired;
    }
    return _expired;
  }

  bool _repeated() {
    if (widget.item.itemPassword != null) {
      if (widget.item.itemPassword.repeatWarning) {
        return widget.item.itemPassword.repeated;
      }
    }
    return false;
  }

  Color _setAvatarColor() {
    if (widget.item.avatarLetterColor >= 0)
      return Color(widget.item.avatarLetterColor);
    Color _c = Color(widget.item.avatarColor);
    double _bgDelta = _c.red * 0.299 + _c.green * 0.587 + _c.blue * 0.114;
    return (255 - _bgDelta > 105) ? Colors.white : Colors.black;
  }

  Color _setIconColor() {
    if (widget.item.itemPassword != null) {
      if (widget.item.itemPassword.repeatWarning &&
          widget.item.itemPassword.repeated) return Colors.grey[200];
    }
    return Colors.grey;
  }

  Color _setWarningColor() {
    if (widget.item.itemPassword != null) {
      if (widget.item.itemPassword.repeatWarning &&
          widget.item.itemPassword.repeated) return Colors.red[300];
    }
    return Colors.grey[100];
  }

  @override
  void initState() {
    _cripto = Provider.of<CriptoProvider>(context, listen: false);
    _title = widget.item.title;
    _subtitle = '';
    _expire = _expired();
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
          backgroundColor: widget.item.avatarColor != null
              ? Color(widget.item.avatarColor)
              : Colors.grey,
          child: _icon == null
              ? Text(
                  widget.item.title.substring(0, 1).toUpperCase(),
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
                _title,
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
              if (_expire && _showValue == 0)
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
              SizedBox(width: 4),
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
