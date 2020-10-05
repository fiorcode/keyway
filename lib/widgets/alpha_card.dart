import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/screens/alpha_screen.dart';
import 'package:keyway/models/item.dart';
import 'package:keyway/providers/cripto_provider.dart';

class AlphaCard extends StatefulWidget {
  AlphaCard(this._alpha);

  final AlphaItem _alpha;

  @override
  _AlphaCardState createState() => _AlphaCardState();
}

class _AlphaCardState extends State<AlphaCard> {
  @override
  Widget build(BuildContext context) {
    CriptoProvider _cProv = Provider.of<CriptoProvider>(context, listen: false);
    return Card(
      clipBehavior: Clip.antiAlias,
      shadowColor: Colors.green,
      elevation: 8,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(width: 3, color: Colors.green)),
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
          if (_cProv.locked) {
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
      ),
    );
  }
}
