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
    return Container(
      height: 56,
      child: _showPass
          ? Center(
              child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(cripto.doDecrypt(widget._alpha.password)),
            ))
          : Center(
              child: Text(
                widget._alpha.title != null ? widget._alpha.title : '',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ),
    );
  }

  Widget _setLeading() => Container(
        height: 48,
        width: 48,
        child: CircleAvatar(
          backgroundColor: widget._alpha.color != null
              ? Color(widget._alpha.color)
              : Colors.grey,
          child: Text(
            widget._alpha.title != null ?? widget._alpha.title.isNotEmpty
                ? widget._alpha.title.substring(0, 1).toUpperCase()
                : '',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );

  Widget _setTrailing() {
    CriptoProvider cripto = Provider.of<CriptoProvider>(context, listen: false);
    return cripto.locked
        ? Chip(
            label: Text(
              widget._alpha.shortDate != null ? widget._alpha.shortDate : '',
              style: TextStyle(fontSize: 12),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 40,
                width: 40,
                child: FloatingActionButton(
                  backgroundColor: Colors.grey[200],
                  child: Icon(Icons.copy, color: Colors.black, size: 20),
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
                height: 40,
                width: 40,
                child: FloatingActionButton(
                  backgroundColor: Colors.grey[200],
                  child: Icon(
                    Icons.remove_red_eye_outlined,
                    color: Colors.black,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _showPass = !_showPass),
                ),
              ),
            ],
          );
  }

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
                builder: (context) => AlphaScreen(item: widget._alpha)))
        .then((_) => widget.onReturn());
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white70,
      clipBehavior: Clip.antiAlias,
      shadowColor: widget._alpha.repeated == 'y'
          ? Colors.red
          : widget._alpha.expired == 'y'
              ? Colors.orange
              : Colors.green,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(48),
        side: BorderSide(
          width: 2,
          color: widget._alpha.repeated == 'y'
              ? Colors.red
              : widget._alpha.expired == 'y'
                  ? Colors.orange
                  : Colors.green,
        ),
      ),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
        leading: _setLeading(),
        title: _setTitle(),
        onTap: _onTap,
        trailing: _setTrailing(),
      ),
    );
  }
}
