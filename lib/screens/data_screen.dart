import 'package:flutter/material.dart';
import 'package:keyway/widgets/alpha_card.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/cripto_provider.dart';
import 'package:keyway/providers/item_provider.dart';

class DataScreen extends StatefulWidget {
  static const routeName = '/data';

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  CriptoProvider cripto;
  ItemProvider items;
  Future getOldItems;
  Future getDeletedItems;

  _getOldItems() async {
    items = Provider.of<ItemProvider>(context, listen: false);
    return await items.fetchAndSetOldItems();
  }

  _getDeletedItems() async {
    items = Provider.of<ItemProvider>(context, listen: false);
    return await items.fetchAndSetDeletedItems();
  }

  Future onReturn() async {
    setState(() {
      getOldItems = _getOldItems();
      getDeletedItems = _getDeletedItems();
    });
  }

  @override
  void initState() {
    getDeletedItems = _getDeletedItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(),
      body: FutureBuilder(
        future: getDeletedItems,
        builder: (ctx, snap) {
          switch (snap.connectionState) {
            case ConnectionState.none:
              return Center(child: Text('none'));
            case (ConnectionState.waiting):
              return Center(child: CircularProgressIndicator());
            case (ConnectionState.done):
              return Stack(
                children: [
                  items.deletedItems.length <= 0
                      ? Center(
                          child: Icon(
                            Icons.blur_on,
                            size: 128,
                            color: Colors.white54,
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(8),
                          itemCount: items.deletedItems.length,
                          itemBuilder: (ctx, i) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1),
                              child: AlphaCard(items.deletedItems[i], onReturn),
                            );
                          },
                        ),
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
