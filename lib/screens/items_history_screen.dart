import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/cripto_provider.dart';
import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/helpers/error_helper.dart';
import 'package:keyway/widgets/unlock_container.dart';
import 'package:keyway/widgets/empty_items.dart';
import 'package:keyway/widgets/Cards/alpha_historyList_card.dart';

class ItemsHistoryScreen extends StatefulWidget {
  static const routeName = '/items-history';
  @override
  _ItemsHistoryScreenState createState() => _ItemsHistoryScreenState();
}

class _ItemsHistoryScreenState extends State<ItemsHistoryScreen> {
  ItemProvider _items;
  CriptoProvider _cripto;
  bool _unlocking = false;
  Future _getOldItems;

  _lockSwitch() => setState(() => _unlocking = !_unlocking);

  Future<void> _getOld() async => await _items.fetchItemsWithOlds();

  onReturn() {
    _getOldItems = _getOld();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _cripto = Provider.of<CriptoProvider>(context);
    _items = Provider.of<ItemProvider>(context);
    _getOldItems = _getOld();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        centerTitle: true,
        title: _cripto.locked
            ? IconButton(
                icon: Icon(
                  Icons.lock_outline,
                  color: _unlocking ? Colors.orange : Colors.red,
                ),
                // onPressed: cripto.locked ? _lockSwitch : null,
                onPressed: () => _cripto.unlock('Qwe123!'),
              )
            : _items.items.length > 10
                ? IconButton(
                    icon: Icon(Icons.search, color: Colors.green),
                    onPressed: null,
                  )
                : IconButton(
                    icon: Icon(Icons.lock_open_sharp, color: Colors.green),
                    onPressed: () => _cripto.lock(),
                  ),
      ),
      body: FutureBuilder(
        future: _getOldItems,
        builder: (ctx, snap) {
          switch (snap.connectionState) {
            case ConnectionState.none:
              return Center(child: Text('none'));
            case (ConnectionState.waiting):
              return Center(child: CircularProgressIndicator());
            case (ConnectionState.done):
              if (snap.hasError)
                return ErrorHelper.errorBody(snap.error);
              else
                return Stack(
                  children: [
                    _items.itemsWithOlds.length <= 0
                        ? EmptyItems()
                        : ListView.builder(
                            padding: EdgeInsets.all(8),
                            itemCount: _items.itemsWithOlds.length,
                            itemBuilder: (ctx, i) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 1),
                                child: AlphaHistoryListCard(
                                  item: _items.itemsWithOlds[i],
                                  onReturn: onReturn,
                                ),
                              );
                            },
                          ),
                    if (_unlocking && _cripto.locked)
                      UnlockContainer(_lockSwitch),
                  ],
                );
              break;
            default:
              return Center(child: Text('default'));
          }
        },
      ),
    );
  }
}
