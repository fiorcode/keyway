import 'package:flutter/material.dart';
import 'package:keyway/widgets/loading_scaffold.dart';
import 'package:provider/provider.dart';

import '../providers/cripto_provider.dart';
import '../providers/item_provider.dart';
import '../screens/item_add_screen.dart';
import '../screens/dashboard_screen.dart';
import '../widgets/card/item_locked_card.dart';
import '../widgets/card/item_unlocked_card.dart';
import '../widgets/unlock_container.dart';
import '../widgets/empty_items.dart';
import '../widgets/text_field/search_bar_text_field.dart';

class ItemsListScreen extends StatefulWidget {
  static const routeName = '/items';

  @override
  _ItemsListScreenState createState() => _ItemsListScreenState();
}

class _ItemsListScreenState extends State<ItemsListScreen> {
  CriptoProvider _cripto;
  ItemProvider _item;
  Future<void> _getItems;

  TextEditingController _searchCtrler = TextEditingController();
  FocusNode _searchFN = FocusNode();

  bool _unlocking = false;
  bool _searching = false;

  _lockSwitch() => setState(() => _unlocking = !_unlocking);

  Future<void> _getItemsAsync() => _item.fetchItems(_searchCtrler.text);

  void _onReturn() {
    _getItems = _getItemsAsync();
    setState(() {});
  }

  void _searchSwitch() {
    setState(() {
      _searching = !_searching;
      _searching ? _searchFN.requestFocus() : _searchFN.unfocus();
      if (!_searching) _clearSearch();
    });
  }

  void _clearSearch() {
    _searchCtrler.clear();
    _getItems = _getItemsAsync();
    setState(() {});
  }

  void _goToDashboard() => Navigator.of(context)
      .pushNamed(DashboardScreen.routeName)
      .then((_) => _onReturn());

  void _goToAlpha() => Navigator.of(context)
      .pushNamed(ItemAddScreen.routeName)
      .then((_) => _onReturn());

  Widget _appBarTitle() {
    if (_cripto.locked) {
      return IconButton(
        icon: Icon(
          Icons.lock_outline,
          color: _unlocking ? Colors.orange : Colors.red,
        ),
        // onPressed: _lockSwitch,
        onPressed: () => _cripto.unlock('Qwe123!'),
      );
    } else {
      if (_searching) {
        _searchFN.requestFocus();
        return SearchBarTextField(
          _searchCtrler,
          _onReturn,
          _searchSwitch,
          _clearSearch,
          _searchFN,
        );
      } else {
        return IconButton(
          icon: Icon(Icons.lock_open_sharp, color: Colors.green),
          onPressed: () {
            _cripto.lock();
            setState(() {});
          },
        );
      }
    }
  }

  @override
  void didChangeDependencies() {
    _cripto = Provider.of<CriptoProvider>(context);
    _item = Provider.of<ItemProvider>(context);
    _getItems = _getItemsAsync();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _searchCtrler.dispose();
    _searchFN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getItems,
        builder: (ctx, snap) {
          switch (snap.connectionState) {
            case ConnectionState.active:
              return LoadingScaffold();
              break;
            case ConnectionState.done:
              if (snap.hasError)
                return Center(child: Image.asset("assets/error.png"));
              else {
                return Scaffold(
                  backgroundColor: Theme.of(context).backgroundColor,
                  appBar: AppBar(
                    backgroundColor: Theme.of(context).backgroundColor,
                    iconTheme:
                        IconThemeData(color: Theme.of(context).primaryColor),
                    centerTitle: true,
                    leading: IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: _goToDashboard,
                    ),
                    title: _appBarTitle(),
                    actions: [
                      if (_item.items.length > 10)
                        IconButton(
                          icon: Icon(Icons.search),
                          onPressed: _searchSwitch,
                        ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: _goToAlpha,
                      )
                    ],
                    actionsIconTheme:
                        IconThemeData(color: Theme.of(context).primaryColor),
                  ),
                  body: Stack(
                    children: [
                      _item.items.length <= 0
                          ? EmptyItems()
                          : ListView.builder(
                              padding: EdgeInsets.all(12.0),
                              itemCount: _item.items.length,
                              itemBuilder: (ctx, i) {
                                return _cripto.locked
                                    ? ItemLockedCard(item: _item.items[i])
                                    : ItemUnlockedCard(
                                        item: _item.items[i],
                                        onReturn: _onReturn,
                                      );
                              },
                            ),
                      if (_unlocking && _cripto.locked)
                        UnlockContainer(_lockSwitch),
                    ],
                  ),
                );
              }
              break;
            default:
              return LoadingScaffold();
          }
        });
  }
}
