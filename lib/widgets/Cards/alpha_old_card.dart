import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:keyway/models/item.dart';
import 'package:keyway/providers/cripto_provider.dart';
import 'package:keyway/screens/old_alpha_view_screen.dart';

class AlphaOldCard extends StatefulWidget {
  const AlphaOldCard({Key key, this.oldAlpha, this.onReturn}) : super(key: key);

  final OldAlpha oldAlpha;
  final Function onReturn;

  @override
  _AlphaOldCardState createState() => _AlphaOldCardState();
}

class _AlphaOldCardState extends State<AlphaOldCard> {
  CriptoProvider _cripto;
  bool _showPass = false;

  Color _setAvatarLetterColor() {
    Color _color = Color(widget.oldAlpha.color);
    double bgDelta =
        _color.red * 0.299 + _color.green * 0.587 + _color.blue * 0.114;
    return (255 - bgDelta > 105) ? Colors.white : Colors.black;
  }

  void _passToClipBoard() {
    Clipboard.setData(ClipboardData(
        text: _cripto.doDecrypt(
      widget.oldAlpha.password,
      widget.oldAlpha.passwordIV,
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

  Text _setTitle() => Text(
        _showPass
            ? _cripto.doDecrypt(
                widget.oldAlpha.password, widget.oldAlpha.passwordIV)
            : widget.oldAlpha.title,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w300,
          color: Colors.black,
        ),
      );

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

  // void _switchShowPass() => setState(() => _showPass = !_showPass);

  void _switchShowPass() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OldAlphaViewScreen(oldAlpha: widget.oldAlpha),
        ),
      ).then((_) => widget.onReturn());

  @override
  void didChangeDependencies() {
    _cripto = Provider.of<CriptoProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shadowColor: _setWarningColor(),
      elevation: 8,
      shape: StadiumBorder(
        side: BorderSide(width: 2, color: Colors.grey),
      ),
      child: ListTile(
        dense: true,
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
        title: _setTitle(),
        onTap: null,
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
                child: FloatingActionButton(
                  backgroundColor: _setWarningColor(),
                  child: Icon(
                    Icons.remove_red_eye_outlined,
                    color: _setIconColor(),
                    size: 24,
                  ),
                  heroTag: null,
                  onPressed: _switchShowPass,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
