import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/models/item.dart';
import 'package:keyway/providers/cripto_provider.dart';
import 'package:keyway/screens/alpha_screen.dart';

class AlphaListTile extends StatefulWidget {
  AlphaListTile(this._alpha);

  final Alpha _alpha;

  @override
  _AlphaListTileState createState() => _AlphaListTileState();
}

class _AlphaListTileState extends State<AlphaListTile> {
  CriptoProvider _cProv;
  bool _decrypted = false;
  String _title = "";
  //String _subTitle = "";
  String _trailing = "";

  @override
  void initState() {
    _cProv = Provider.of<CriptoProvider>(context, listen: false);
    _initialState();
    super.initState();
  }

  void _initialState() {
    _title = widget._alpha.title;
    DateTime _date = DateTime.parse(widget._alpha.date);
    _trailing =
        '${_date.day.toString()}/${_date.month.toString()}/${_date.year.toString()}';
    _decrypted = false;
  }

  @override
  void didUpdateWidget(AlphaListTile oldWidget) {
    _initialState();
    super.didUpdateWidget(oldWidget);
  }

  void _decrypt() {
    _title = _cProv.doDecrypt(widget._alpha.password);
    //_subTitle = "";
    _trailing = "";
    _decrypted = true;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(widget._alpha.title.substring(0, 1).toUpperCase()),
      ),
      title: Text(_title),
      //subtitle: _subTitle.isNotEmpty ? Text(_subTitle) : null,
      trailing: _trailing.isNotEmpty ? Text(_trailing) : null,
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
            builder: (context) => AlphaScreen(
              item: widget._alpha,
            ),
          ),
        );
      },
      onLongPress: () {
        if (_cProv.locked) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('Please unlock'),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }
        if (_decrypted)
          _initialState();
        else
          _decrypt();
      },
    );
  }
}
