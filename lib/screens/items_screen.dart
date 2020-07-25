import 'package:flutter/material.dart';
import 'package:keyway/screens/alpha_screen.dart';
import 'package:keyway/screens/keyhole_screen.dart';
import 'package:provider/provider.dart';

import '../providers/cripto_provider.dart';
import '../providers/item_provider.dart';

class ItemsListScreen extends StatefulWidget {
  static const routeName = '/items';

  @override
  _ItemsListScreenState createState() => _ItemsListScreenState();
}

class _ItemsListScreenState extends State<ItemsListScreen> {
  CriptoProvider _cp;
  ItemProvider _ip;
  @override
  Widget build(BuildContext context) {
    _cp = Provider.of<CriptoProvider>(context);
    _ip = Provider.of<ItemProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: _cp.locked
            ? IconButton(
                icon: Icon(
                  Icons.lock_outline,
                  color: Colors.red,
                ),
                onPressed: () =>
                    Navigator.of(context).pushNamed(KeyholeScreen.routeName),
              )
            : IconButton(
                icon: Icon(
                  Icons.lock_open,
                  color: Colors.green,
                ),
                onPressed: null),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(AlphaScreen.routeName);
              })
        ],
      ),
      body: FutureBuilder(
        future: _ip.fetchAndSetItems(),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : Consumer<ItemProvider>(
                    child: Center(
                      child: const Text('Got no data yet, start adding some'),
                    ),
                    builder: (ctx, lib, ch) => lib.items.length <= 0
                        ? ch
                        : ListView.builder(
                            itemCount: lib.items.length,
                            itemBuilder: (ctx, i) {
                              return Text(lib.items[i].title);
                            },
                          ),
                  ),
      ),
    );
  }
}
