import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/cripto_provider.dart';
import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/helpers/error_helper.dart';
import 'package:keyway/widgets/empty_items.dart';
import 'package:keyway/widgets/unlock_container.dart';
import 'package:keyway/widgets/Cards/alpha_deleted_card.dart';

class DeletedItemsScreen extends StatefulWidget {
  static const routeName = '/deleted-items';

  @override
  _DeletedItemsScreenState createState() => _DeletedItemsScreenState();
}

class _DeletedItemsScreenState extends State<DeletedItemsScreen> {
  ItemProvider _items;
  CriptoProvider _cripto;
  bool _unlocking = false;
  Future getDeletedItems;

  _lockSwitch() => setState(() => _unlocking = !_unlocking);

  Future<void> _getDeletedItems() async => await _items.fetchDeletedItems();

  void _onReturn() {
    getDeletedItems = _getDeletedItems();
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
    getDeletedItems = _getDeletedItems();
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
        future: getDeletedItems,
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
                    _items.deletedItems.length <= 0
                        ? EmptyItems()
                        : ListView.builder(
                            padding: EdgeInsets.all(12.0),
                            itemCount: _items.deletedItems.length,
                            itemBuilder: (ctx, i) {
                              return AlphaDeletedCard(
                                alpha: _items.deletedItems[i],
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
