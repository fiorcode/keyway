import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:keyway/models/item.dart';
import 'package:keyway/providers/cripto_provider.dart';
import 'package:keyway/screens/alpha_view_screen.dart';

class AlphaDeletedCard extends StatefulWidget {
  const AlphaDeletedCard({Key key, this.alpha, this.onReturn})
      : super(key: key);

  final DeletedAlpha alpha;
  final Function onReturn;

  @override
  _AlphaDeletedCardState createState() => _AlphaDeletedCardState();
}

class _AlphaDeletedCardState extends State<AlphaDeletedCard> {
  CriptoProvider _cripto;
  bool _visible = false;

  Color _setAvatarLetterColor() {
    Color _color = Color(widget.alpha.color);
    double bgDelta =
        _color.red * 0.299 + _color.green * 0.587 + _color.blue * 0.114;
    return (255 - bgDelta > 105) ? Colors.white : Colors.black;
  }

  void _passToClipBoard() {
    Clipboard.setData(
            ClipboardData(text: _cripto.doDecrypt(widget.alpha.password)))
        .then(
      (_) => Scaffold.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text('Copied'),
          duration: Duration(seconds: 1),
        ),
      ),
    );
  }

  Column _setTitle() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _visible
                ? _cripto.doDecrypt(widget.alpha.password)
                : widget.alpha.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              fontSize: _visible ? 16 : 22,
              fontWeight: FontWeight.w300,
              color: Colors.black,
            ),
          ),
          Text(
            _visible ?? widget.alpha.username.isNotEmpty
                ? _cripto.doDecrypt(widget.alpha.username)
                : widget.alpha.shortDate,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              fontSize: 12,
            ),
          )
        ],
      );

  Color _setWarningColor() {
    return (widget.alpha.passStatus == 'REPEATED' ||
            widget.alpha.pinStatus == 'REPEATED')
        ? Colors.red[300]
        : Colors.grey[100];
  }

  Color _setIconColor() {
    return (widget.alpha.passStatus == 'REPEATED' ||
            widget.alpha.pinStatus == 'REPEATED')
        ? Colors.grey[200]
        : Colors.grey;
  }

  void _showPass() {
    if (widget.alpha.password.isNotEmpty)
      setState(() => _visible = !_visible);
    else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AlphaViewScreen(alpha: widget.alpha),
        ),
      ).then((_) => widget.onReturn());
    }
  }

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
        side: BorderSide(width: 2, color: Colors.red),
      ),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.all(4),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: widget.alpha.color != null
              ? Color(widget.alpha.color).withOpacity(0.33)
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
        onTap: null,
        trailing: Padding(
          padding: const EdgeInsets.all(4.0),
          child: _cripto.locked
              ? null
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 48,
                      width: 48,
                      child: FloatingActionButton(
                        backgroundColor: _setWarningColor(),
                        child:
                            Icon(Icons.copy, color: _setIconColor(), size: 24),
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
                        onPressed: _showPass,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
