import 'package:flutter/material.dart';
import 'package:keyway/helpers/error_helper.dart';
import 'package:provider/provider.dart';

import 'item_edit_screen.dart';
import 'item_old_passwords_screen.dart';

import '../providers/cripto_provider.dart';
import '../providers/item_provider.dart';
import '../helpers/warning_helper.dart';
import '../models/item.dart';
import '../widgets/item_view_container.dart';

class ItemViewScreen extends StatefulWidget {
  static const routeName = '/item-view';

  ItemViewScreen({this.itemId});

  final int itemId;

  @override
  _ItemViewScreenState createState() => _ItemViewScreenState();
}

class _ItemViewScreenState extends State<ItemViewScreen> {
  CriptoProvider _cripto;
  Future<void> _getItem;
  Item _i;

  void _onReturn() {
    _getItem = _getItemAsync();
    setState(() {});
  }

  Future<Item> _getItemAsync() async {
    ItemProvider _items = Provider.of<ItemProvider>(context, listen: false);
    return _items.getItem(widget.itemId);
  }

  void _goToEditItem() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemEditScreen(item: _i),
      ),
    ).then((_) => _onReturn());
  }

  void _goToPasswordHistory() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItemOldPasswordsScreen(item: _i),
        ),
      );

  void _deleteItem() async {
    bool _warning = await WarningHelper.deleteItem(context);
    _warning = _warning == null ? false : _warning;
    if (_warning) {
      ItemProvider _items = Provider.of<ItemProvider>(context, listen: false);
      _i.setDeleted();
      _items.updateItem(_i, _i).then(
            (_) => Navigator.of(context).pop(),
          );
    }
  }

  @override
  void initState() {
    _cripto = Provider.of<CriptoProvider>(context, listen: false);
    _getItem = _getItemAsync();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          centerTitle: true,
          title: FutureBuilder(
              future: _getItem,
              builder: (ctx, snap) {
                switch (snap.connectionState) {
                  case ConnectionState.active:
                    return null;
                    break;
                  case ConnectionState.done:
                    _i = snap.data;
                    return Text(
                      _i.title,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    );
                    break;
                  default:
                    return null;
                }
              }),
          actions: [
            IconButton(icon: Icon(Icons.edit), onPressed: _goToEditItem)
          ],
          actionsIconTheme:
              IconThemeData(color: Theme.of(context).primaryColor),
        ),
        body: FutureBuilder(
          future: _getItem,
          builder: (ctx, snap) {
            switch (snap.connectionState) {
              case ConnectionState.active:
                return LinearProgressIndicator();
                break;
              case ConnectionState.done:
                if (snap.hasError)
                  return ErrorHelper.errorBody(snap.error);
                else {
                  _i = snap.data;
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (_i.username != null)
                            ItemViewContainer(
                              'username',
                              _cripto.decryptUsername(_i.username),
                            ),
                          if (_i.password != null)
                            Container(
                              width: double.infinity,
                              height: 92,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 3.0,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 2,
                                      horizontal: 4,
                                    ),
                                    color: Colors.black,
                                    child: Text(
                                      'password',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        _cripto.decryptPassword(_i.password),
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w300,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (_i.passwords.length > 1)
                                    Expanded(
                                      child: Center(
                                        child: TextButton(
                                          onPressed: _goToPasswordHistory,
                                          child: Text(
                                            'OLD PASSWORDS',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          if (_i.pin != null)
                            ItemViewContainer(
                              'pin',
                              _cripto.decryptPin(_i.pin),
                            ),
                          if (_i.note != null)
                            ItemViewContainer(
                              'note',
                              _cripto.decryptNote(_i.note),
                            ),
                          if (_i.address != null)
                            Container(
                              width: double.infinity,
                              height: 92,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 3.0,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 2,
                                          horizontal: 4,
                                        ),
                                        color: Colors.black,
                                        child: Text(
                                          _i.address.addressProtocol,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 2,
                                          horizontal: 4,
                                        ),
                                        color: Colors.black,
                                        child: Text(
                                          'address',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 2,
                                          horizontal: 4,
                                        ),
                                        color: Colors.black,
                                        child: Text(
                                          _i.address.addressPort.toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        _cripto.decryptAddress(_i.address),
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w300,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (_i.product != null)
                            Container(
                              width: double.infinity,
                              height: 160,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 3.0,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 2,
                                      horizontal: 4,
                                    ),
                                    color: Colors.black,
                                    child: Text(
                                      'product',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  ),
                                  if (_i.product.productTrademark.isNotEmpty)
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          'trademark',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (_i.product.productTrademark.isNotEmpty)
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          _i.product.productTrademark[0]
                                                  .toUpperCase() +
                                              _i.product.productTrademark
                                                  .substring(1),
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w300,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (_i.product.productModel.isNotEmpty)
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          'model',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (_i.product.productModel.isNotEmpty)
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          _i.product.productModel[0]
                                                  .toUpperCase() +
                                              _i.product.productModel
                                                  .substring(1),
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w300,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ElevatedButton.icon(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.red),
                            icon: Icon(Icons.delete, color: Colors.white),
                            label: Text(
                              'DELETE ITEM',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: _deleteItem,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                break;
              default:
                return Center(child: Text('default'));
            }
          },
        ));
  }
}
