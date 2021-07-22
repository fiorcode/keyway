import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../providers/cripto_provider.dart';
import '../../models/item.dart';
import '../../screens/item_edit_screen.dart';
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
  String _subtitle = '';

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
        builder: (context) => ItemEditScreen(item: widget.item),
      ),
    ).then((_) => widget.onReturn());
  }

  Color _setAvatarLetterColor() {
    if (widget.item.avatarLetterColor >= 0)
      return Color(widget.item.avatarLetterColor);
    Color _c = Color(widget.item.avatarColor);
    double _bgDelta = _c.red * 0.299 + _c.green * 0.587 + _c.blue * 0.114;
    return (255 - _bgDelta > 105) ? Colors.white : Colors.black;
  }

  void _passToClipBoard() async {
    Clipboard.setData(ClipboardData(text: _setTitleSubtitle())).then(
      (_) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(_subtitle + ' copied'),
          duration: Duration(seconds: 1),
        ),
      ),
    );
  }

  bool _expired() {
    DateTime _nowUTC = DateTime.now().toUtc();
    bool _passExp = false;
    bool _pinExp = false;
    if (widget.item.itemPassword != null) {
      DateTime _passDate =
          DateTime.parse(widget.item.itemPassword.passwordDate);
      int _daysOfPass = _nowUTC.difference(_passDate).inDays;
      _passExp = widget.item.itemPassword.passwordLapse <= _daysOfPass;
      if (widget.item.itemPassword.passwordLapse <= 0) _passExp = false;
    }
    if (widget.item.pin != null) {
      DateTime _pinDate = DateTime.parse(widget.item.pin.pinDate);
      int _daysOfPin = _nowUTC.difference(_pinDate).inDays;
      _pinExp = widget.item.pin.pinLapse <= _daysOfPin;
      if (widget.item.pin.pinLapse <= 0) _pinExp = false;
    }
    return _passExp || _pinExp;
  }

  String _setTitleSubtitle() {
    switch (_showValue) {
      case 1:
        if (widget.item.password == null) continue two;
        _showValue = 1;
        _subtitle = 'Password';
        return _cripto.doDecrypt(
            widget.item.password.passwordEnc, widget.item.password.passwordIv);
        break;
      two:
      case 2:
        if (widget.item.pin == null) continue three;
        _showValue = 2;
        _subtitle = 'PIN';
        return _cripto.doDecrypt(widget.item.pin.pinEnc, widget.item.pin.pinIv);
        break;
      three:
      case 3:
        if (widget.item.username == null) continue four;
        _showValue = 3;
        _subtitle = 'Username';
        return _cripto.doDecrypt(
            widget.item.username.usernameEnc, widget.item.username.usernameIv);
        break;
      four:
      case 4:
        if (widget.item.address == null) continue five;
        _showValue = 4;
        _subtitle =
            'Protocol: ${widget.item.address.addressProtocol}, Port: ${widget.item.address.addressPort}';
        return widget.item.address.addressEnc;
        break;
      five:
      case 5:
        if (widget.item.product == null) continue cero;
        _showValue = 5;
        _subtitle = 'Product';
        return '${widget.item.product.productTrademark}, ${widget.item.product.productModel}';
        break;
      cero:
      default:
        _showValue = 0;
        _subtitle = '';
        return widget.item.title;
    }
  }

  Widget _setAvatarIcon() {
    switch (_showValue) {
      case 1:
        return Icon(Icons.password, color: _setAvatarLetterColor());
        break;
      case 2:
        return Icon(Icons.pin, color: _setAvatarLetterColor());
        break;
      case 3:
        return Icon(Icons.account_box, color: _setAvatarLetterColor());
        break;
      case 4:
        return Icon(Icons.http, color: _setAvatarLetterColor());
        break;
      case 5:
        return Icon(Icons.router, color: _setAvatarLetterColor());
        break;
      default:
        _showValue = 0;
        _subtitle = '';
        return Text(
          widget.item.title != null ?? widget.item.title.isNotEmpty
              ? widget.item.title.substring(0, 1).toUpperCase()
              : '',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: _setAvatarLetterColor(),
          ),
        );
    }
  }

  Color _setWarningColor() {
    if (widget.item.itemPassword != null) {
      if (widget.item.itemPassword.repeated) return Colors.red[300];
    }
    return Colors.grey[100];
  }

  Color _setIconColor() {
    if (widget.item.itemPassword != null) {
      if (widget.item.itemPassword.repeated) return Colors.grey[200];
    }
    return Colors.grey;
  }

  void _switchShowValue() => setState(() {
        if (_showValue > 6)
          _showValue = 0;
        else
          _showValue++;
      });

  void _showPassLongPressed() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItemViewScreen(item: widget.item),
        ),
      ).then((_) => widget.onReturn());

  @override
  void initState() {
    _cripto = Provider.of<CriptoProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shadowColor: _setWarningColor(),
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
          child: _setAvatarIcon(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                _setTitleSubtitle(),
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
            if (_showValue != 0)
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
              if (_expired() && _showValue == 0)
                SizedBox(
                  height: 48,
                  width: 48,
                  child: Icon(
                    Icons.calendar_today,
                    color: Colors.red,
                    size: 24,
                  ),
                ),
              if (_showValue != 0)
                SizedBox(
                  height: 48,
                  width: 48,
                  child: FloatingActionButton(
                    backgroundColor: _setWarningColor(),
                    child: Icon(Icons.copy, color: _setIconColor(), size: 24),
                    heroTag: null,
                    onPressed: _passToClipBoard,
                  ),
                ),
              SizedBox(width: 4),
              SizedBox(
                height: 48,
                width: 48,
                child: InkWell(
                  onLongPress: _showPassLongPressed,
                  child: FloatingActionButton(
                    backgroundColor: _setWarningColor(),
                    child: Icon(
                      Icons.remove_red_eye_outlined,
                      color: _setIconColor(),
                      size: 24,
                    ),
                    heroTag: null,
                    onPressed: _switchShowValue,
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
