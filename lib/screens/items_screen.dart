import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/cripto_provider.dart';
import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/screens/alpha_screen.dart';
import 'package:keyway/screens/dashboard_screen.dart';
import 'package:keyway/widgets/alpha_card.dart';
import 'package:keyway/widgets/unlock_container.dart';

class ItemsListScreen extends StatefulWidget {
  static const routeName = '/items';

  @override
  _ItemsListScreenState createState() => _ItemsListScreenState();
}

class _ItemsListScreenState extends State<ItemsListScreen> {
  CriptoProvider cripto;
  ItemProvider items;
  bool _unlocking = false;
  Future getItems;

  _lockSwitch() {
    setState(() {
      _unlocking = !_unlocking;
    });
  }

  _getItems() async {
    items = Provider.of<ItemProvider>(context, listen: false);
    return await items.fetchAndSetItems();
  }

  Future onReturn() async {
    setState(() {
      getItems = _getItems();
    });
  }

  @override
  void initState() {
    getItems = _getItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    cripto = Provider.of<CriptoProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        leading: cripto.locked
            ? null
            : IconButton(
                icon: Icon(Icons.settings),
                onPressed: () =>
                    Navigator.of(context).pushNamed(DashboardScreen.routeName),
              ),
        title: cripto.locked
            ? IconButton(
                icon: Icon(
                  Icons.lock_outline,
                  color: _unlocking ? Colors.orange : Colors.red,
                ),
                onPressed: cripto.locked ? _lockSwitch : null,
              )
            : IconButton(
                icon: Icon(Icons.lock_open, color: Colors.green),
                onPressed: null),
        actions: cripto.locked
            ? null
            : [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(AlphaScreen.routeName)
                        .then((_) => onReturn());
                  },
                )
              ],
      ),
      body: FutureBuilder(
        future: getItems,
        builder: (ctx, snap) {
          switch (snap.connectionState) {
            case ConnectionState.none:
              return Center(child: Text('none'));
            case (ConnectionState.waiting):
              return Center(child: CircularProgressIndicator());
            case (ConnectionState.done):
              return Stack(
                children: [
                  items.items.length <= 0
                      ? Center(
                          child: Icon(
                            Icons.blur_on,
                            size: 128,
                            color: Colors.white54,
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(8),
                          itemCount: items.items.length,
                          itemBuilder: (ctx, i) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1),
                              child: AlphaCard(items.items[i]),
                            );
                          },
                        ),
                  if (_unlocking && cripto.locked) UnlockContainer(_lockSwitch),
                ],
              );
            default:
              return Center(child: Text('default'));
          }
        },
      ),
    );
  }
}
