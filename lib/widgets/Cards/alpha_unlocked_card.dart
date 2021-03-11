import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:keyway/models/alpha.dart';
import 'package:keyway/providers/cripto_provider.dart';
import 'package:keyway/screens/alpha_edit_screen.dart';
import 'package:keyway/screens/alpha_view_screen.dart';

class AlphaUnlockedCard extends StatefulWidget {
  const AlphaUnlockedCard({Key key, this.alpha, this.onReturn})
      : super(key: key);

  final Alpha alpha;
  final Function onReturn;

  @override
  _AlphaUnlockedCardState createState() => _AlphaUnlockedCardState();
}

class _AlphaUnlockedCardState extends State<AlphaUnlockedCard> {
  int _showValue = 0;
  String _subtitle = '';

  void _onTap() {
    CriptoProvider cripto = Provider.of<CriptoProvider>(context, listen: false);
    if (cripto.locked) {
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
        builder: (context) => AlphaEditScreen(alpha: widget.alpha),
      ),
    ).then((_) => widget.onReturn());
  }

  Color _setAvatarLetterColor() {
    if (widget.alpha.colorLetter >= 0) return Color(widget.alpha.colorLetter);
    Color _c = Color(widget.alpha.color);
    double _bgDelta = _c.red * 0.299 + _c.green * 0.587 + _c.blue * 0.114;
    return (255 - _bgDelta > 105) ? Colors.white : Colors.black;
  }

  void _passToClipBoard() {
    Clipboard.setData(ClipboardData(text: _title())).then(
      (_) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(_subtitle + ' copied'),
          duration: Duration(seconds: 1),
        ),
      ),
    );
  }

  String _title() {
    CriptoProvider cripto = Provider.of<CriptoProvider>(context, listen: false);
    switch (_showValue) {
      case 1:
        if (widget.alpha.password.isEmpty) continue two;
        _showValue = 1;
        _subtitle = 'Password';
        return cripto.doDecrypt(widget.alpha.password, widget.alpha.passwordIV);
        break;
      two:
      case 2:
        if (widget.alpha.pin.isEmpty) continue three;
        _showValue = 2;
        _subtitle = 'PIN';
        return cripto.doDecrypt(widget.alpha.pin, widget.alpha.pinIV);
        break;
      three:
      case 3:
        if (widget.alpha.username.isEmpty) continue four;
        _showValue = 3;
        _subtitle = 'Username';
        return cripto.doDecrypt(widget.alpha.username, widget.alpha.usernameIV);
        break;
      four:
      case 4:
        if (widget.alpha.ip.isEmpty) continue cero;
        _showValue = 4;
        _subtitle = 'IP';
        return cripto.doDecrypt(widget.alpha.ip, widget.alpha.ipIV);
        break;
      cero:
      default:
        _showValue = 0;
        _subtitle = '';
        return widget.alpha.title;
    }
  }

  Column _setTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _title(),
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
    );
  }

  Color _setWarningColor() {
    return (widget.alpha.passwordStatus == 'REPEATED' ||
            widget.alpha.pinStatus == 'REPEATED')
        ? Colors.red[300]
        : Colors.grey[100];
  }

  Color _setIconColor() {
    return (widget.alpha.passwordStatus == 'REPEATED' ||
            widget.alpha.pinStatus == 'REPEATED')
        ? Colors.red
        : Colors.grey;
  }

  void _switchShowValue() {
    if (_showValue > 4)
      _showValue = 0;
    else
      _showValue++;
    setState(() {});
  }

  void _showPassLongPressed() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AlphaViewScreen(alpha: widget.alpha),
        ),
      ).then((_) => widget.onReturn());

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
          backgroundColor: widget.alpha.color != null
              ? Color(widget.alpha.color)
              : Colors.grey,
          child: Text(
            widget.alpha.title != null ?? widget.alpha.title.isNotEmpty
                ? widget.alpha.title.substring(0, 1).toUpperCase()
                : '',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _setAvatarLetterColor(),
            ),
          ),
        ),
        title: _setTitle(),
        onTap: _onTap,
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
