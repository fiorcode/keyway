import 'package:flutter/material.dart';
import 'package:keyway/widgets/alpha_card.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/cripto_provider.dart';
import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/screens/keyhole_screen.dart';
import 'package:keyway/screens/alpha_screen.dart';
import 'package:keyway/screens/dashboard_screen.dart';
// import 'package:keyway/widgets/alpha_list_tile.dart';

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
        leading: IconButton(
            icon: Icon(Icons.dashboard),
            onPressed: () =>
                Navigator.of(context).pushNamed(DashboardScreen.routeName)),
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
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AlphaCard(lib.items[i]),
                              );
                            },
                          ),
                  ),
      ),
    );
  }
}
