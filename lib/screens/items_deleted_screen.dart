import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../providers/cripto_provider.dart';
import '../providers/item_provider.dart';
import '../helpers/error_helper.dart';
import '../widgets/empty_items.dart';
import '../widgets/card/item_deleted_card.dart';

class ItemsDeletedScreen extends StatefulWidget {
  static const routeName = '/items-deleted';

  @override
  _ItemsDeletedScreenState createState() => _ItemsDeletedScreenState();
}

class _ItemsDeletedScreenState extends State<ItemsDeletedScreen> {
  // CriptoProvider _cripto;
  ItemProvider _items;
  Future _getItemsDeleted;

  Future<void> _getItemsDeletedAsync() async =>
      await _items.fetchItemsDeleted();

  void _onReturn() {
    _getItemsDeleted = _getItemsDeletedAsync();
    setState(() {});
  }

  @override
  void initState() {
    // _cripto = Provider.of<CriptoProvider>(context, listen: false);
    _items = Provider.of<ItemProvider>(context, listen: false);
    _getItemsDeleted = _getItemsDeletedAsync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        centerTitle: true,
        title: _items.items.length > 10
            ? IconButton(
                icon: Icon(Icons.search, color: Colors.green),
                onPressed: null,
              )
            : Icon(
                Icons.delete,
                color: Colors.red,
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
                return _items.itemsDeleted.length <= 0
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
