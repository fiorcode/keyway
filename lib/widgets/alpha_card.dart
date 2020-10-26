import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:keyway/screens/alpha_screen.dart';
import 'package:keyway/models/item.dart';
import 'package:keyway/providers/cripto_provider.dart';

class AlphaCard extends StatefulWidget {
  AlphaCard(this._alpha);

  final Alpha _alpha;

  @override
  _AlphaCardState createState() => _AlphaCardState();
}

class _AlphaCardState extends State<AlphaCard> {
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
            width: 3,
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
        title: Text(widget._alpha.title != null ? widget._alpha.title : ''),
        subtitle: Text(
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
          );
        },
        trailing: cripto.locked
            ? null
            : GestureDetector(
                child: Icon(Icons.copy_rounded),
                onTap: () => Clipboard.setData(ClipboardData(
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
    );
  }
}
