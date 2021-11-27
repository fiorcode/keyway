import 'package:flutter/material.dart';
import 'package:keyway/helpers/error_helper.dart';
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
  Future<void>? _getPins;
  late List<Pin> _pins;

  Future<void> _getNotesAsync() async {
    ItemProvider _ip = Provider.of<ItemProvider>(context, listen: false);
    _pins = await _ip.fetchPins();
    CriptoProvider _cp = Provider.of<CriptoProvider>(context, listen: false);
    Future.forEach(_pins, (dynamic p) => _cp.decryptPin(p));
  }

  Future<void> _deletePin(Pin p) async {
    ItemProvider _ip = Provider.of<ItemProvider>(context, listen: false);
    await _ip
        .deletePin(p)
        .onError((error, st) => ErrorHelper.errorDialog(context, error));
    _getPins = _getNotesAsync();
    setState(() {});
  }

  @override
  void initState() {
    _getPins = _getNotesAsync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              case ConnectionState.done:
                return ListView.builder(
                    padding: EdgeInsets.all(12.0),
                    itemCount: _pins.length,
                    itemBuilder: (ctx, i) {
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.pin, size: 38),
                          title: Text(_pins[i].pinDec),
                          trailing: IconButton(
                            onPressed: () => _deletePin(_pins[i]),
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
