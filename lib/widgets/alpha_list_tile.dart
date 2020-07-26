import 'package:flutter/material.dart';
import 'package:keyway/screens/alpha_screen.dart';
import 'package:provider/provider.dart';

import 'package:keyway/models/item.dart';
import 'package:keyway/providers/cripto_provider.dart';

class AlphaListTile extends StatefulWidget {
  AlphaListTile(this._alpha);

  final AlphaItem _alpha;

  @override
  _AlphaListTileState createState() => _AlphaListTileState();
}

class _AlphaListTileState extends State<AlphaListTile> {
  bool _decrypted = false;
  String _title = "";
  String _subTitle = "";

  @override
  void initState() {
    _initialState();
    super.initState();
  }

  void _initialState() {
    setState(() {
      _title = widget._alpha.title;
      _subTitle = '${DateTime.parse(widget._alpha.date).day.toString()}' +
          '/' +
          '${DateTime.parse(widget._alpha.date).month.toString()}' +
          '/' +
          '${DateTime.parse(widget._alpha.date).year.toString()}';
      _decrypted = false;
    });
  }

  void _decrypt() async {
    CriptoProvider _cProv = Provider.of<CriptoProvider>(context, listen: false);
    _title = await _cProv.doDecrypt(widget._alpha.password);
    _subTitle = "";
    _decrypted = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    CriptoProvider _cProv = Provider.of<CriptoProvider>(context);
    return ListTile(
      leading: CircleAvatar(
        child: Text(widget._alpha.title.substring(0, 1).toUpperCase()),
      ),
      title: Text(_title),
      subtitle: _subTitle.isNotEmpty ? Text(_subTitle) : null,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AlphaScreen(
            item: widget._alpha,
          ),
        ),
      ),
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
