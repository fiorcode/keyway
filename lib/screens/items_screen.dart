import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/date_helper.dart';
import '../helpers/password_helper.dart';
import '../models/tag.dart';
import '../models/item.dart';
import '../providers/cripto_provider.dart';
import '../providers/item_provider.dart';
import '../screens/item_add_screen.dart';
import '../screens/item_view_screen.dart';
import '../widgets/card/item_cleartext_card.dart';
import '../widgets/empty_items.dart';
import '../widgets/loading_scaffold.dart';
import '../screens/dashboard_screen.dart';
import '../widgets/card/item_locked_card.dart';
import '../widgets/card/item_unlocked_card.dart';
import '../widgets/unlock_container.dart';
import '../widgets/text_field/search_bar_text_field.dart';
import '../widgets/tags_filter_list.dart';

class ItemsListScreen extends StatefulWidget {
  static const routeName = '/items';

  @override
  _ItemsListScreenState createState() => _ItemsListScreenState();
}

class _ItemsListScreenState extends State<ItemsListScreen> {
  Future<void>? _getItems;
  List<Item> _items = <Item>[];
  Tag? _tag;

  TextEditingController _searchCtrler = TextEditingController();
  FocusNode _searchFN = FocusNode();

  bool _unlocking = false;
  bool _searching = false;
  bool _working = false;

  _lockSwitch() => setState(() => _unlocking = !_unlocking);

  void _searchSwitch() {
    setState(() {
      _searching = !_searching;
      _searching ? _searchFN.requestFocus() : _searchFN.unfocus();
      if (!_searching) _clearSearch();
    });
  }

  void _search() {
    ItemProvider _item = Provider.of<ItemProvider>(context, listen: false);
    if (_searchCtrler.text.isNotEmpty) {
      _items = _item.items
          .where((i) =>
              i.title!.toLowerCase().contains(_searchCtrler.text.toLowerCase()))
          .toList();
    } else {
      _items = _item.items;
    }
    setState(() {});
  }

  void _tagsSwitch(Tag tag) {
    ItemProvider _item = Provider.of<ItemProvider>(context, listen: false);
    if (tag.selected!) {
      _tag = tag;
      _items = _item.items
          .where((i) => i.tags!.contains('<' + _tag!.tagName! + '>'))
          .toList();
      setState(() {});
    } else {
      _tag = null;
      _items = _item.items;
      setState(() {});
    }
  }

  Future<void> _getItemsAsync() async => _items =
      await Provider.of<ItemProvider>(context, listen: false).fetchItems();

  void _onReturn() {
    _tag = null;
    _getItems = _getItemsAsync();
    setState(() {});
  }

  void _clearSearch() {
    _searchCtrler.clear();
    _items = Provider.of<ItemProvider>(context, listen: false).items;
    setState(() {});
  }

  void _goToDashboard() {
    Navigator.of(context)
        .pushNamed(DashboardScreen.routeName)
        .then((_) => _onReturn());
  }

  void _goToItemView(Item i) {
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
        builder: (context) => ItemViewScreen(item: i, onReturn: _onReturn),
      ),
    );
  }

  void _goToAlpha() {
    Navigator.of(context)
        .pushNamed(ItemAddScreen.routeName)
        .then((_) => _onReturn());
  }

  Future<void> _generatePassword() async {
    setState(() => _working = true);
    Item _i = Item(
      title: (await PasswordHelper.dicePassword()).password,
      itemStatus: '<cleartext>',
      avatarColor: Colors.white.value,
      avatarLetterColor: Colors.black.value,
    );
    _i.itemId =
        await Provider.of<ItemProvider>(context, listen: false).insertItem(_i);
    _items.add(_i);
    _items.sort((a, b) => DateHelper.compare(b.date!, a.date!));
    setState(() => _working = false);
  }

  Future<void> _buildRandomItem(Item old, Item i) async {
    setState(() => _working = true);
    ItemProvider _i = Provider.of<ItemProvider>(context, listen: false);
    i.itemId = await _i.insertItem(i);
    await _i.deleteItem(old);
    _items.remove(old);
    _items.add(i);
    _items.sort((a, b) => DateHelper.compare(b.date!, a.date!));
    setState(() => _working = false);
  }

  Future<void> _deleteRandomItem(Item i) async {
    setState(() => _working = true);
    await Provider.of<ItemProvider>(context, listen: false)
        .deleteCleartextItem(i);
    _items.remove(i);
    _items.sort((a, b) => DateHelper.compare(b.date!, a.date!));
    setState(() => _working = false);
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
        // onPressed: () => _cripto.unlock('Qwe123!'),
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
    CriptoProvider _cripto = Provider.of<CriptoProvider>(context);
    Color _primary = Theme.of(context).primaryColor;
    Color _back = Theme.of(context).backgroundColor;
    return FutureBuilder(
        future: _getItems,
        builder: (ctx, snap) {
          switch (snap.connectionState) {
            case ConnectionState.waiting:
              return LoadingScaffold();
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
                      if (_items.length > 10)
                        IconButton(
                          icon: Icon(Icons.search),
                          onPressed: _searchSwitch,
                        ),
                      IconButton(
                        icon: Icon(Icons.flash_on),
                        onPressed: () => _generatePassword(),
                      ),
                      if (!_cripto.locked)
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: _goToAlpha,
                        )
                    ],
                    actionsIconTheme: IconThemeData(color: _primary),
                  ),
                  body: Stack(children: [
                    _items.length < 1
                        ? EmptyItems()
                        : Column(
                            children: [
                              if (_working) LinearProgressIndicator(),
                              if (_items.isNotEmpty)
                                TagsFilterList(_tag, _tagsSwitch),
                              Expanded(
                                child: ListView.builder(
                                  key: UniqueKey(),
                                  padding: EdgeInsets.all(12.0),
                                  shrinkWrap: true,
                                  itemCount: _items.length,
                                  itemBuilder: (ctx, i) {
                                    if (_cripto.locked) {
                                      return ItemLockedCard(item: _items[i]);
                                    } else if (_items[i].cleartext) {
                                      return ItemCleartextCard(
                                        item: _items[i],
                                        deleteItem: _deleteRandomItem,
                                        buildItem: _buildRandomItem,
                                      );
                                    } else {
                                      return ItemUnlockedCard(
                                        item: _items[i],
                                        onTap: () => _goToItemView(_items[i]),
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
