import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:keyway/screens/alpha_screen.dart';
import 'package:keyway/models/item.dart';
import 'package:keyway/providers/cripto_provider.dart';

class AlphaUnlockedCard extends StatefulWidget {
  const AlphaUnlockedCard({Key key, this.alpha, this.onReturn})
      : super(key: key);

  final Alpha alpha;
  final Function onReturn;

  @override
  _AlphaUnlockedCardState createState() => _AlphaUnlockedCardState();
}

class _AlphaUnlockedCardState extends State<AlphaUnlockedCard> {
  bool _showPass = false;

  _onTap() {
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
        builder: (context) => AlphaScreen(item: widget.alpha),
      ),
    ).then((_) => widget.onReturn());
  }

  Color _setAvatarLetterColor() {
    Color _color = Color(widget.alpha.color);
    double bgDelta =
        _color.red * 0.299 + _color.green * 0.587 + _color.blue * 0.114;
    return (255 - bgDelta > 105) ? Colors.white : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    CriptoProvider cripto = Provider.of<CriptoProvider>(context, listen: false);
    return Card(
      //color: Colors.grey[400],
      clipBehavior: Clip.antiAlias,
      shadowColor: widget.alpha.repeated == 'y'
          ? Colors.red
          : widget.alpha.expired == 'y'
              ? Colors.orange
              : Colors.green,
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
        title: _showPass
            ? Text(
                cripto.doDecrypt(widget.alpha.password),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
              )
            : Text(
                widget.alpha.title != null ? widget.alpha.title : '',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
              ),
        onTap: _onTap,
        trailing: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 32,
                width: 32,
                child: FloatingActionButton(
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.copy,
                    color: Colors.white,
                    size: 16,
                  ),
                  heroTag: null,
                  onPressed: () => Clipboard.setData(ClipboardData(
                          text: cripto.doDecrypt(widget.alpha.password)))
                      .then(
                    (_) => Scaffold.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('Copied'),
                        duration: Duration(seconds: 1),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              SizedBox(
                height: 32,
                width: 32,
                child: FloatingActionButton(
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.remove_red_eye_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                  heroTag: null,
                  onPressed: () => setState(() => _showPass = !_showPass),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
