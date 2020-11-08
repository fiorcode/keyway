import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:keyway/screens/alpha_screen.dart';
import 'package:keyway/models/item.dart';
import 'package:keyway/providers/cripto_provider.dart';

class AlphaCard extends StatefulWidget {
  AlphaCard(this._alpha, this.onReturn);

  final Alpha _alpha;
  final Function onReturn;

  @override
  _AlphaCardState createState() => _AlphaCardState();
}

class _AlphaCardState extends State<AlphaCard> {
  bool _showPass = false;

  Widget _setTitle() {
    CriptoProvider cripto = Provider.of<CriptoProvider>(context, listen: false);
    return _showPass
        ? Center(
            child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(cripto.doDecrypt(widget._alpha.password)),
          ))
        : Text(widget._alpha.title != null ? widget._alpha.title : '');
  }

  @override
  Widget build(BuildContext context) {
    CriptoProvider cripto = Provider.of<CriptoProvider>(context, listen: false);
    return Card(
      clipBehavior: Clip.antiAlias,
      shadowColor: widget._alpha.repeated == 'y'
          ? Colors.red
          : widget._alpha.expired == 'y'
              ? Colors.orange
              : Colors.green,
      elevation: 8,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            width: 2,
            color: widget._alpha.repeated == 'y'
                ? Colors.red
                : widget._alpha.expired == 'y'
                    ? Colors.orange
                    : Colors.green,
          )),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: widget._alpha.color != null
              ? Color(widget._alpha.color)
              : Colors.grey,
          child: Text(
            widget._alpha.title != null ?? widget._alpha.title.isNotEmpty
                ? widget._alpha.title.substring(0, 1).toUpperCase()
                : '',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        title: _setTitle(),
        subtitle: _showPass
            ? null
            : Text(
                widget._alpha.shortDate != null ? widget._alpha.shortDate : ''),
        onTap: () {
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
              builder: (context) => AlphaScreen(item: widget._alpha),
            ),
          ).then((_) => widget.onReturn());
        },
        trailing: cripto.locked
            ? null
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 32,
                    width: 32,
                    child: FloatingActionButton(
                      backgroundColor: Colors.grey[200],
                      child: Icon(Icons.copy, color: Colors.black, size: 16),
                      onPressed: () => Clipboard.setData(ClipboardData(
                              text: cripto.doDecrypt(widget._alpha.password)))
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
                      backgroundColor: Colors.grey[200],
                      child: Icon(
                        Icons.remove_red_eye_outlined,
                        color: Colors.black,
                        size: 16,
                      ),
                      onPressed: () => setState(() => _showPass = !_showPass),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
