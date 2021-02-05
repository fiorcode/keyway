import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:keyway/models/item.dart';
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
  bool _showPassword = false;
  int _showValue = 0;

  void _onTap() {
    CriptoProvider cripto = Provider.of<CriptoProvider>(context, listen: false);
    if (cripto.locked) {
      Scaffold.of(context).showSnackBar(
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
    Color _color = Color(widget.alpha.color);
    double bgDelta =
        _color.red * 0.299 + _color.green * 0.587 + _color.blue * 0.114;
    return (255 - bgDelta > 105) ? Colors.white : Colors.black;
  }

  void _passToClipBoard() {
    CriptoProvider cripto = Provider.of<CriptoProvider>(context, listen: false);
    Clipboard.setData(ClipboardData(
        text: cripto.doDecrypt(
      widget.alpha.password,
      widget.alpha.passwordIV,
    ))).then(
      (_) => Scaffold.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text('Copied'),
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
        return cripto.doDecrypt(widget.alpha.password, widget.alpha.passwordIV);
        break;
      two:
      case 2:
        if (widget.alpha.pin.isEmpty) continue three;
        return cripto.doDecrypt(widget.alpha.pin, widget.alpha.pinIV);
        break;
      three:
      case 3:
        if (widget.alpha.username.isEmpty) continue four;
        return cripto.doDecrypt(widget.alpha.username, widget.alpha.usernameIV);
        break;
      four:
      case 4:
        if (widget.alpha.ip.isEmpty) continue cero;
        return cripto.doDecrypt(widget.alpha.ip, widget.alpha.ipIV);
        break;
      cero:
      default:
        return widget.alpha.title;
    }
  }

  Text _setTitle() {
    return Text(
      _title(),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w300,
        color: Colors.black,
      ),
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
        ? Colors.grey[200]
        : Colors.grey;
  }

  void _switchShowValue() => setState(() {
        // if (_showValue > 3) _showValue = 0;
        if (widget.alpha.password.isEmpty)
          _showValue++;
        else
          return;
        if (widget.alpha.pin.isNotEmpty && _showValue == 1) {
          _showValue++;
          return;
        }
        if (widget.alpha.username.isNotEmpty && _showValue == 2) {
          _showValue++;
          return;
        }
        if (widget.alpha.ip.isNotEmpty && _showValue == 3) {
          _showValue++;
          return;
        }
      });

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
