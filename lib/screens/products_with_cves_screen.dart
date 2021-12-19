import 'package:flutter/material.dart';
import 'package:keyway/providers/item_provider.dart';
import 'package:provider/provider.dart';

import '../helpers/error_helper.dart';
import '../models/item.dart';
import '../providers/cripto_provider.dart';
import '../screens/item_view_screen.dart';
import '../widgets/card/item_cleartext_card.dart';
import '../widgets/empty_items.dart';
import '../widgets/loading_scaffold.dart';
import '../widgets/card/item_locked_card.dart';
import '../widgets/card/item_unlocked_card.dart';
import '../widgets/unlock_container.dart';

class ProductsWithCvesScreen extends StatefulWidget {
  static const routeName = '/products-with-cves';

  @override
  _ProductsWithCvesScreenState createState() => _ProductsWithCvesScreenState();
}

class _ProductsWithCvesScreenState extends State<ProductsWithCvesScreen> {
  Future<void>? _getItemsWithCves;
  List<Item> _itemsProduct = <Item>[];

  bool _unlocking = false;
  bool _working = false;

  _lockSwitch() => setState(() => _unlocking = !_unlocking);

  Future<void> _getItemsWithCvesAsync() async =>
      _itemsProduct = await Provider.of<ItemProvider>(context, listen: false)
          .getItemsWithCves();

  void _onReturn() {
    _getItemsWithCves = _getItemsWithCvesAsync();
    setState(() {});
  }

  void _goToItemProductView(Item i) {
    if (Provider.of<CriptoProvider>(context, listen: false).locked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please unlock'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemViewScreen(item: i),
      ),
    ).then((_) => _onReturn());
  }

  Widget _appBarTitle() {
    CriptoProvider _cripto = Provider.of<CriptoProvider>(context);
    if (_cripto.locked) {
      return IconButton(
        icon: Icon(
          Icons.lock_outline,
          color: _unlocking ? Colors.orange : Colors.red,
        ),
        onPressed: _lockSwitch,
      );
    } else {
      return IconButton(
        icon: Icon(Icons.lock_open_sharp, color: Colors.green),
        onPressed: () => _cripto.lock(),
      );
    }
  }

  @override
  void initState() {
    _getItemsWithCves = _getItemsWithCvesAsync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CriptoProvider _cripto = Provider.of<CriptoProvider>(context);
    Color _primary = Theme.of(context).primaryColor;
    Color _back = Theme.of(context).backgroundColor;
    return FutureBuilder(
        future: _getItemsWithCves,
        builder: (ctx, snap) {
          switch (snap.connectionState) {
            case ConnectionState.waiting:
              return LoadingScaffold();
            case ConnectionState.done:
              if (snap.hasError)
                return ErrorHelper.errorScaffold(snap.error);
              else {
                return Scaffold(
                  backgroundColor: _back,
                  appBar: AppBar(
                    backgroundColor: _back,
                    iconTheme: IconThemeData(color: _primary),
                    centerTitle: true,
                    title: _appBarTitle(),
                    actionsIconTheme: IconThemeData(color: _primary),
                  ),
                  body: Stack(children: [
                    _itemsProduct.length < 1
                        ? EmptyItems()
                        : Column(
                            children: [
                              if (_working) LinearProgressIndicator(),
                              Expanded(
                                child: ListView.builder(
                                  key: UniqueKey(),
                                  padding: EdgeInsets.all(12.0),
                                  shrinkWrap: true,
                                  itemCount: _itemsProduct.length,
                                  itemBuilder: (ctx, i) {
                                    if (_cripto.locked) {
                                      return ItemLockedCard(
                                          item: _itemsProduct[i]);
                                    } else if (_itemsProduct[i].cleartext) {
                                      return ItemCleartextCard(
                                        item: _itemsProduct[i],
                                        // deleteItem: _deleteRandomItem,
                                        // buildItem: _buildRandomItem,
                                      );
                                    } else {
                                      return ItemUnlockedCard(
                                        item: _itemsProduct[i],
                                        onTap: () => _goToItemProductView(
                                            _itemsProduct[i]),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                    if (_unlocking && _cripto.locked)
                      UnlockContainer(_lockSwitch)
                  ]),
                );
              }
            default:
              return LoadingScaffold();
          }
        });
  }
}
