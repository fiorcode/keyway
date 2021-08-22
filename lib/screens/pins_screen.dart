import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/cripto_provider.dart';
import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/models/pin.dart';
import 'package:keyway/widgets/loading_scaffold.dart';

class PinsScreen extends StatefulWidget {
  static const routeName = '/pins';

  @override
  _PinsScreenState createState() => _PinsScreenState();
}

class _PinsScreenState extends State<PinsScreen> {
  ItemProvider _item;
  Future<void> _getPins;

  Future<void> _getNotesAsync() => _item.fetchPins();

  Future<void> _deletePin(Pin p) async {
    await _item.deletePin(p);
    _getPins = _getNotesAsync();
    setState(() {});
  }

  @override
  void initState() {
    _item = Provider.of<ItemProvider>(context, listen: false);
    _getPins = _getNotesAsync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CriptoProvider _cripto =
        Provider.of<CriptoProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: FutureBuilder(
          future: _getPins,
          builder: (ctx, snap) {
            switch (snap.connectionState) {
              case ConnectionState.waiting:
                return LoadingScaffold();
                break;
              case ConnectionState.done:
                return ListView.builder(
                    padding: EdgeInsets.all(12.0),
                    itemCount: _item.pins.length,
                    itemBuilder: (ctx, i) {
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.pin, size: 38),
                          title: Text(_cripto.decryptPin(_item.pins[i])),
                          trailing: IconButton(
                            onPressed: () => _deletePin(_item.pins[i]),
                            icon: Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                              size: 32,
                            ),
                          ),
                        ),
                      );
                    });
              default:
                return Text('default');
            }
          }),
    );
  }
}
