import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/error_helper.dart';
import '../providers/cripto_provider.dart';
import '../providers/item_provider.dart';
import '../widgets/unlock_container.dart';
import '../widgets/Cards/alpha_locked_card.dart';
import '../widgets/Cards/alpha_unlocked_card.dart';
import '../widgets/empty_items.dart';
import '../widgets/TextFields/search_bar_text_field.dart';

class AllItemsListScreen extends StatefulWidget {
  static const routeName = '/all-items';

  @override
  _AllItemsListScreenState createState() => _AllItemsListScreenState();
}

class _AllItemsListScreenState extends State<AllItemsListScreen> {
  ItemProvider _item;
  CriptoProvider _cripto;
  Future _getAllItemsAsync;
  TextEditingController _searchCtrler;
  FocusNode _searchFocusNode;
  bool _unlocking = false;
  bool _searching = false;

  _lockSwitch() => setState(() => _unlocking = !_unlocking);

  Future<void> _getAllItems() async => await _item.fetchAllItems(
        _searchCtrler.text == null ? '' : _searchCtrler.text,
      );

  _onReturn() {
    _getAllItemsAsync = _getAllItems();
    setState(() {});
  }

  void _searchSwitch() {
    setState(() {
      _searching = !_searching;
      _searching ? _searchFocusNode.requestFocus() : _searchFocusNode.unfocus();
      if (!_searching) _clearSearch();
    });
  }

  void _clearSearch() {
    _searchCtrler.clear();
    _getAllItemsAsync = _getAllItems();
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    _cripto = Provider.of<CriptoProvider>(context);
    _item = Provider.of<ItemProvider>(context);
    _searchCtrler = TextEditingController();
    _searchFocusNode = FocusNode();
    _getAllItemsAsync = _getAllItems();
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
                // onPressed: _lockSwitch,
                onPressed: () => _cripto.unlock('Qwe123!'),
              )
            : FutureBuilder(
                future: _getAllItemsAsync,
                builder: (ctx, snap) {
                  switch (snap.connectionState) {
                    case ConnectionState.done:
                      if (_item.allItems.length > 10 || _searching) {
                        if (_searching) {
                          _searchFocusNode.requestFocus();
                          return SearchBarTextField(
                            _searchCtrler,
                            _onReturn,
                            _searchSwitch,
                            _clearSearch,
                            _searchFocusNode,
                          );
                        } else {
                          return IconButton(
                            icon: Icon(Icons.search),
                            onPressed: _searchSwitch,
                          );
                        }
                      }
                      return IconButton(
                        icon: Icon(Icons.lock_open_sharp, color: Colors.green),
                        onPressed: () {
                          _cripto.lock();
                          setState(() {});
                        },
                      );
                      break;
                    default:
                      return CircularProgressIndicator(
                        backgroundColor: Colors.grey,
                      );
                  }
                },
              ),
      ),
      body: FutureBuilder(
        future: _getAllItemsAsync,
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
                    _item.allItems.length <= 0
                        ? EmptyItems()
                        : ListView.builder(
                            padding: EdgeInsets.all(12.0),
                            itemCount: _item.allItems.length,
                            itemBuilder: (ctx, i) {
                              return _cripto.locked
                                  ? AlphaLockedCard(item: _item.allItems[i])
                                  : AlphaUnlockedCard(
                                      item: _item.allItems[i],
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
