import 'package:flutter/material.dart';
import 'package:keyway/widgets/Cards/alpha_locked_card.dart';
import 'package:keyway/widgets/Cards/alpha_unlocked_card.dart';
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

  Future<void> _getOldItems() async {
    items = Provider.of<ItemProvider>(context, listen: false);
    return await items.fetchAndSetOldItems();
  }

  Future<void> _getDeletedItems() async {
    items = Provider.of<ItemProvider>(context, listen: false);
    return await items.fetchAndSetDeletedItems();
  }

  onReturn() async {
    getOldItems = _getOldItems();
    getDeletedItems = _getDeletedItems();
    setState(() {});
  }

  @override
  void initState() {
    cripto = Provider.of<CriptoProvider>(context, listen: false);
    getDeletedItems = _getDeletedItems();
    getOldItems = _getOldItems();
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
        future: getOldItems,
        builder: (ctx, snap) {
          switch (snap.connectionState) {
            case ConnectionState.none:
              return Center(child: Text('none'));
            case (ConnectionState.waiting):
              return Center(child: CircularProgressIndicator());
            case (ConnectionState.done):
              return Stack(
                children: [
                  items.oldItems.length <= 0
                      ? Center(
                          child: Icon(
                            Icons.blur_on,
                            size: 128,
                            color: Colors.white54,
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(8),
                          itemCount: items.oldItems.length,
                          itemBuilder: (ctx, i) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1),
                              child: cripto.locked
                                  ? AlphaLockedCard(alpha: items.oldItems[i])
                                  : AlphaUnlockedCard(
                                      alpha: items.oldItems[i],
                                      onReturn: onReturn,
                                    ),
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
