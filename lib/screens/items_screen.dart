import 'package:flutter/material.dart';
import 'package:keyway/widgets/empty_items.dart';
import 'package:keyway/widgets/loading_scaffold.dart';
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
import '../widgets/text_field/search_bar_text_field.dart';
import 'package:keyway/widgets/tags_filter_list.dart';

class ItemsListScreen extends StatefulWidget {
  static const routeName = '/items';

  @override
  _ItemsListScreenState createState() => _ItemsListScreenState();
}

class _ItemsListScreenState extends State<ItemsListScreen> {
  CriptoProvider _cripto;
  ItemProvider _item;
  Future<void> _getItems;
  List<Item> _items = <Item>[];
  Tag _tag;

  TextEditingController _searchCtrler = TextEditingController();
  FocusNode _searchFN = FocusNode();

  bool _unlocking = false;
  bool _searching = false;

  _lockSwitch() => setState(() => _unlocking = !_unlocking);

  void _searchSwitch() {
    setState(() {
      _searching = !_searching;
      _searching ? _searchFN.requestFocus() : _searchFN.unfocus();
      if (!_searching) _clearSearch();
    });
  }

  void _search() {
    if (_searchCtrler.text.isNotEmpty) {
      _items = _item.items
          .where((i) =>
              i.title.toLowerCase().contains(_searchCtrler.text.toLowerCase()))
          .toList();
    } else {
      _items = _item.items;
    }
    setState(() {});
  }

  void _tagsSwitch(Tag tag) {
    if (tag.selected) {
      _tag = tag;
      _items = _item.items
          .where((i) => i.tags.contains('<' + _tag.tagName + '>'))
          .toList();
      setState(() {});
    } else {
      _tag = null;
      _items = _item.items;
      setState(() {});
    }
  }

  Future<void> _getItemsAsync() async => _items = await _item.fetchItems();

  void _onReturn() {
    _tag = null;
    _getItems = _getItemsAsync();
    setState(() {});
  }

  void _clearSearch() {
    _searchCtrler.clear();
    _items = _item.items;
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
        onPressed: _lockSwitch,
      );
    } else {
      if (_searching) {
        _searchFN.requestFocus();
        return SearchBarTextField(
          _searchCtrler,
          _search,
          _searchSwitch,
          _clearSearch,
          _searchFN,
        );
      } else {
        return IconButton(
          icon: Icon(Icons.lock_open_sharp, color: Colors.green),
          onPressed: () => _cripto.lock(),
        );
      }
    }
  }

  @override
  void initState() {
    _item = Provider.of<ItemProvider>(context, listen: false);
    _getItems = _getItemsAsync();
    super.initState();
  }

  @override
  void dispose() {
    _searchCtrler.dispose();
    _searchFN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _cripto = Provider.of<CriptoProvider>(context);
    Color _primary = Theme.of(context).primaryColor;
    Color _back = Theme.of(context).backgroundColor;
    return FutureBuilder(
        future: _getItems,
        builder: (ctx, snap) {
          switch (snap.connectionState) {
            case ConnectionState.waiting:
              return LoadingScaffold();
              break;
            case ConnectionState.done:
              if (snap.hasError)
                return Center(
                  child: Image.asset("assets/error.png"),
                );
              else {
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
                  body: _item.items.length < 1
                      ? EmptyItems()
                      : Stack(children: [
                          Column(
                            children: [
                              if (_item.items.isNotEmpty)
                                TagsFilterList(_tag, _tagsSwitch),
                              Expanded(
                                child: ListView.builder(
                                  key: UniqueKey(),
                                  padding: EdgeInsets.all(12.0),
                                  shrinkWrap: true,
                                  itemCount: _items.length,
                                  itemBuilder: (ctx, i) {
                                    return _cripto.locked
                                        ? ItemLockedCard(item: _items[i])
                                        : ItemUnlockedCard(
                                            item: _items[i],
                                            onReturn: _onReturn,
                                          );
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
              break;
            default:
              return LoadingScaffold();
          }
        });
  }
}
