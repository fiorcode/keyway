import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cripto_provider.dart';
import '../providers/item_provider.dart';
import '../helpers/error_helper.dart';
import '../widgets/empty_items.dart';
import '../widgets/unlock_container.dart';
import '../widgets/Cards/item_deleted_card.dart';

class ItemsDeletedScreen extends StatefulWidget {
  static const routeName = '/items-deleted';

  @override
  _ItemsDeletedScreenState createState() => _ItemsDeletedScreenState();
}

class _ItemsDeletedScreenState extends State<ItemsDeletedScreen> {
  ItemProvider _items;
  CriptoProvider _cripto;
  bool _unlocking = false;
  Future _getItemsDeleted;

  _lockSwitch() => setState(() => _unlocking = !_unlocking);

  Future<void> _getItemsDeletedAsync() async =>
      await _items.fetchItemsDeleted();

  void _onReturn() {
    _getItemsDeleted = _getItemsDeletedAsync();
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
    _getItemsDeleted = _getItemsDeletedAsync();
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
                onPressed: () {
                  _cripto.unlock('Qwe123!');
                  setState(() {});
                },
              )
            : _items.items.length > 10
                ? IconButton(
                    icon: Icon(Icons.search, color: Colors.green),
                    onPressed: null,
                  )
                : IconButton(
                    icon: Icon(Icons.lock_open_sharp, color: Colors.green),
                    onPressed: () {
                      _cripto.lock();
                      setState(() {});
                    },
                  ),
      ),
      body: FutureBuilder(
        future: _getItemsDeleted,
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
                    _items.itemsDeleted.length <= 0
                        ? EmptyItems()
                        : ListView.builder(
                            padding: EdgeInsets.all(12.0),
                            itemCount: _items.itemsDeleted.length,
                            itemBuilder: (ctx, i) {
                              return ItemDeletedCard(
                                item: _items.itemsDeleted[i],
                                onReturn: _onReturn,
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
