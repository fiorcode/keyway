import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:keyway/models/old_alpha.dart';
import 'package:keyway/providers/cripto_provider.dart';
import 'package:keyway/providers/item_provider.dart';

class OldAlphaListTile extends StatefulWidget {
  const OldAlphaListTile({Key key, this.oldAlpha, this.onReturn})
      : super(key: key);

  final OldAlpha oldAlpha;
  final Function onReturn;

  @override
  _OldAlphaListTileState createState() => _OldAlphaListTileState();
}

class _OldAlphaListTileState extends State<OldAlphaListTile> {
  CriptoProvider _cripto;
  ItemProvider _items;
  int _showValue = 0;
  String _subtitle = '';

  Color _setAvatarLetterColor() {
    if (widget.oldAlpha.colorLetter >= 0)
      return Color(widget.oldAlpha.colorLetter);
    Color _c = Color(widget.oldAlpha.color);
    double _bgDelta = _c.red * 0.299 + _c.green * 0.587 + _c.blue * 0.114;
    return (255 - _bgDelta > 105) ? Colors.white : Colors.black;
  }

  void _passToClipBoard() {
    Clipboard.setData(ClipboardData(text: _setTitleSubtitle())).then(
      (_) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(_subtitle + 'copied'),
          duration: Duration(seconds: 1),
        ),
      ),
    );
  }

  String _setTitleSubtitle() {
    switch (_showValue) {
      case 1:
        if (widget.oldAlpha.passwordChange.isEmpty) continue two;
        _showValue = 1;
        _subtitle = 'Password ' + widget.oldAlpha.passwordChange;
        return _cripto.doDecrypt(
            widget.oldAlpha.password, widget.oldAlpha.passwordIV);
        break;
      two:
      case 2:
        if (widget.oldAlpha.pinChange.isEmpty) continue three;
        _showValue = 2;
        _subtitle = 'PIN ' + widget.oldAlpha.pinChange;
        return _cripto.doDecrypt(widget.oldAlpha.pin, widget.oldAlpha.pinIV);
        break;
      three:
      case 3:
        if (widget.oldAlpha.username.isEmpty) continue four;
        _showValue = 3;
        _subtitle = 'Username';
        return _cripto.doDecrypt(
            widget.oldAlpha.username, widget.oldAlpha.usernameIV);
        break;
      four:
      case 4:
        if (widget.oldAlpha.ip.isEmpty) continue cero;
        _showValue = 4;
        _subtitle = 'IP';
        return _cripto.doDecrypt(widget.oldAlpha.ip, widget.oldAlpha.ipIV);
        break;
      cero:
      default:
        _showValue = 0;
        _subtitle = '';
        return widget.oldAlpha.title;
    }
  }

  Color _setWarningColor() {
    return (widget.oldAlpha.passwordStatus == 'REPEATED' ||
            widget.oldAlpha.pinStatus == 'REPEATED')
        ? Colors.red[300]
        : Colors.grey[100];
  }

  Color _setIconColor() {
    return (widget.oldAlpha.passwordStatus == 'REPEATED' ||
            widget.oldAlpha.pinStatus == 'REPEATED')
        ? Colors.grey[200]
        : Colors.grey;
  }

  void _delete() async {
    await _items.deleteOldAlpha(widget.oldAlpha);
    widget.onReturn();
  }

  @override
  void initState() {
    _cripto = Provider.of<CriptoProvider>(context, listen: false);
    _items = Provider.of<ItemProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(4),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: widget.oldAlpha.color != null
            ? Color(widget.oldAlpha.color).withOpacity(0.33)
            : Colors.grey,
        child: Text(
          widget.oldAlpha.title != null ?? widget.oldAlpha.title.isNotEmpty
              ? widget.oldAlpha.title.substring(0, 1).toUpperCase()
              : '',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: _setAvatarLetterColor(),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _setTitleSubtitle(),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w300,
              color: Colors.black,
            ),
          ),
          if (_showValue != 0)
            Text(
              _subtitle,
              style: TextStyle(color: Colors.grey),
            ),
        ],
      ),
      onTap: () {},
      trailing: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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
            if (_showValue == 0)
              SizedBox(
                height: 48,
                width: 48,
                child: FloatingActionButton(
                  backgroundColor: Colors.red[300],
                  child: Icon(
                    Icons.delete_forever,
                    color: Colors.white,
                    size: 24,
                  ),
                  heroTag: null,
                  onPressed: _delete,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
