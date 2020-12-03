import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/helpers/error_helper.dart';
import 'package:keyway/widgets/Cards/alpha_locked_card.dart';
import 'package:keyway/widgets/Cards/alpha_unlocked_card.dart';
import 'package:keyway/widgets/empty_items.dart';
import 'package:keyway/widgets/unlock_container.dart';
import 'package:keyway/providers/cripto_provider.dart';
import 'package:keyway/providers/item_provider.dart';

class ItemHistoryScreen extends StatefulWidget {
  static const routeName = '/item-history';
  const ItemHistoryScreen({Key key, this.itemId}) : super(key: key);

  final int itemId;

  @override
  _ItemHistoryScreenState createState() => _ItemHistoryScreenState();
}

class _ItemHistoryScreenState extends State<ItemHistoryScreen> {
  ItemProvider _items;
  CriptoProvider _cripto;
  bool _unlocking = false;
  Future getItems;

  _lockSwitch() => setState(() => _unlocking = !_unlocking);

  Future<void> _getItems() async => await _items.fetchItems();

  onReturn() {
    getItems = _getItems();
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
    getItems = _getItems();
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
        future: getItems,
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
                    _items.items.length <= 0
                        ? EmptyItems()
                        : ListView.builder(
                            padding: EdgeInsets.all(12.0),
                            itemCount: _items.items.length,
                            itemBuilder: (ctx, i) {
                              return _cripto.locked
                                  ? AlphaLockedCard(alpha: _items.items[i])
                                  : AlphaUnlockedCard(
                                      alpha: _items.items[i],
                                      onReturn: onReturn,
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
