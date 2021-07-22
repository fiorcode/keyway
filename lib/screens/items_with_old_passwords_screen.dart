import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cripto_provider.dart';
import '../providers/item_provider.dart';
import '../helpers/error_helper.dart';
import '../widgets/unlock_container.dart';
import '../widgets/empty_items.dart';
import '../widgets/card/item_with_old_passwords_card.dart';

class ItemsWithOldPasswordsScreen extends StatefulWidget {
  static const routeName = '/items-with-old-passwords';
  @override
  _ItemsWithOldPasswordsScreenState createState() =>
      _ItemsWithOldPasswordsScreenState();
}

class _ItemsWithOldPasswordsScreenState
    extends State<ItemsWithOldPasswordsScreen> {
  ItemProvider _items;
  CriptoProvider _cripto;
  bool _unlocking = false;
  Future _getItemsWithOldPasswords;

  _lockSwitch() => setState(() => _unlocking = !_unlocking);

  Future<void> _getItemsWithOldPasswordsAsync() async =>
      await _items.fetchItemsWithOldPasswords();

  onReturn() {
    _getItemsWithOldPasswords = _getItemsWithOldPasswordsAsync();
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
    _getItemsWithOldPasswords = _getItemsWithOldPasswordsAsync();
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
        future: _getItemsWithOldPasswords,
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
                    _items.itemsWithOldPasswords.length <= 0
                        ? EmptyItems()
                        : ListView.builder(
                            padding: EdgeInsets.all(8),
                            itemCount: _items.itemsWithOldPasswords.length,
                            itemBuilder: (ctx, i) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 1),
                                child: ItemWithOldPasswordsCard(
                                  item: _items.itemsWithOldPasswords[i],
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
