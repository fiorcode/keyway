import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cripto_provider.dart';
import '../providers/item_provider.dart';
import '../models/tag.dart';
import '../models/item.dart';
import '../screens/item_add_screen.dart';
import '../screens/dashboard_screen.dart';
import '../widgets/card/item_locked_card.dart';
import '../widgets/card/item_unlocked_card.dart';
import '../widgets/unlock_container.dart';
// import '../widgets/empty_items.dart';
import '../widgets/text_field/search_bar_text_field.dart';
import 'package:keyway/widgets/tags_filter_list.dart';
// import '../widgets/item_filter_list.dart';
// import '../widgets/loading_scaffold.dart';

class ItemsListScreen extends StatefulWidget {
  static const routeName = '/items';

  @override
  _ItemsListScreenState createState() => _ItemsListScreenState();
}

class _ItemsListScreenState extends State<ItemsListScreen> {
  CriptoProvider _cripto;
  ItemProvider _item;
  Future<List<Item>> _getItems;
  Tag _tag;

  TextEditingController _searchCtrler = TextEditingController();
  FocusNode _searchFN = FocusNode();

  bool _unlocking = false;
  bool _searching = false;
  bool _deleted = false;
  bool _oldPassword = false;

  _lockSwitch() => setState(() => _unlocking = !_unlocking);

  void _searchSwitch() {
    setState(() {
      _searching = !_searching;
      _searching ? _searchFN.requestFocus() : _searchFN.unfocus();
      if (!_searching) _clearSearch();
    });
  }

  // void _deletedSwitch() {
  //   _deleted = !_deleted;
  //   _deleted
  //       ? _getItems = _getItemsDeletedAsync()
  //       : _getItems = _getItemsAsync();
  //   setState(() {});
  // }

  // void _oldPasswordSwitch() {
  //   if (_deleted) _deleted = false;
  //   _oldPassword = !_oldPassword;
  //   _oldPassword
  //       ? _getItems = _getItemsDeletedAsync()
  //       : _getItems = _getItemsAsync();
  //   setState(() {});
  // }

  void _tagsSwitch(Tag tag) {
    _tag = null;
    if (tag.selected) _tag = tag;
    if (_tag != null) {
      _getItems = _getItemsWithTag(_tag);
    } else {
      _getItems = _getItemsAsync();
    }
    if (_deleted) _deleted = false;
    if (_oldPassword) _oldPassword = false;
    setState(() {});
  }

  Future<List<Item>> _getItemsAsync() => _item.fetchItems(_searchCtrler.text);

  // Future<void> _getItemsDeletedAsync() => _item.fetchItemsDeleted();

  Future<void> _getItemsWithTag(Tag t) => _item.fetchItemsWithTag(t);

  void _onReturn() {
    _getItems = _getItemsAsync();
    setState(() {});
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
    Color _primary = Theme.of(context).primaryColor;
    Color _back = Theme.of(context).backgroundColor;
    return Scaffold(
      backgroundColor: _back,
      appBar: AppBar(
        backgroundColor: _back,
        iconTheme: IconThemeData(color: _primary),
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
        actionsIconTheme: IconThemeData(color: _primary),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              TagsFilterList(_tag, _tagsSwitch),
              // ItemFilterList(
              //   _deleted,
              //   _deletedSwitch,
              //   _oldPassword,
              //   _oldPasswordSwitch,
              // ),
              FutureBuilder(
                  future: _getItems,
                  builder: (ctx, snap) {
                    switch (snap.connectionState) {
                      case ConnectionState.waiting:
                        return Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Center(
                                  child: Image.asset(
                                    "assets/icon.png",
                                    height: 256,
                                  ),
                                ),
                              ),
                              LinearProgressIndicator(),
                            ],
                          ),
                        );
                        break;
                      case ConnectionState.done:
                        if (snap.hasError)
                          return Center(
                            child: Image.asset("assets/error.png"),
                          );
                        else {
                          return Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.all(12.0),
                              shrinkWrap: true,
                              itemCount: snap.data.length,
                              itemBuilder: (ctx, i) {
                                return _cripto.locked
                                    ? ItemLockedCard(item: snap.data[i])
                                    : ItemUnlockedCard(
                                        item: snap.data[i],
                                        onReturn: _onReturn,
                                      );
                              },
                            ),
                          );
                        }
                        break;
                      default:
                        return LinearProgressIndicator();
                    }
                  }),
            ],
          ),
          if (_unlocking && _cripto.locked) UnlockContainer(_lockSwitch),
        ],
      ),
    );
  }
}
