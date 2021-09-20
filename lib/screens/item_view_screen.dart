import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'item_edit_screen.dart';
import 'item_old_passwords_screen.dart';

import '../providers/cripto_provider.dart';
import '../providers/item_provider.dart';
import '../helpers/warning_helper.dart';
import '../models/item.dart';
import '../widgets/item_view_container.dart';
import '../widgets/loading_scaffold.dart';

class ItemViewScreen extends StatefulWidget {
  static const routeName = '/item-view';

  ItemViewScreen({this.item});

  final Item item;

  @override
  _ItemViewScreenState createState() => _ItemViewScreenState();
}

class _ItemViewScreenState extends State<ItemViewScreen> {
  CriptoProvider _cripto;
  ItemProvider _items;
  Item _i;
  bool _loading = false;
  Future<void> _getPasswords;

  Future<void> _onReturn(Item iUpdated) async {
    if (iUpdated != null) setState(() => _i = iUpdated);
    //if (changed) await _getItem();
  }

  Future<void> _getPasswordsAsync() async {
    _items = Provider.of<ItemProvider>(context, listen: false);
    _getPasswords = _items.loadPasswords(_i);
  }

  void _goToEditItem() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemEditScreen(item: _i),
      ),
    ).then((item) => _onReturn(item));
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
    _i = widget.item;
    _getPasswords = _getPasswordsAsync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _cripto = Provider.of<CriptoProvider>(context, listen: false);
    if (_loading)
      return LoadingScaffold();
    else
      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          centerTitle: true,
          title: Text(
            _i.title,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(icon: Icon(Icons.edit), onPressed: _goToEditItem)
          ],
          actionsIconTheme:
              IconThemeData(color: Theme.of(context).primaryColor),
        ),
        body: SingleChildScrollView(
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
                            style: TextStyle(fontSize: 18, color: Colors.white),
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
                        FutureBuilder(
                          future: _getPasswords,
                          builder: (ctx, snap) {
                            switch (snap.connectionState) {
                              case ConnectionState.waiting:
                                return LinearProgressIndicator();
                                break;
                              case ConnectionState.done:
                                if (snap.hasError)
                                  return Text(snap.error);
                                else {
                                  if (_i.itemPasswords.isNotEmpty) {
                                    return Expanded(
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
                                    );
                                  } else {
                                    return SizedBox(height: 0);
                                  }
                                }
                                break;
                              default:
                                return LinearProgressIndicator();
                            }
                          },
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    fontSize: 18, color: Colors.white),
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
                                    fontSize: 18, color: Colors.white),
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
                                    fontSize: 18, color: Colors.white),
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
                            style: TextStyle(fontSize: 18, color: Colors.white),
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
                                _i.product.productTrademark[0].toUpperCase() +
                                    _i.product.productTrademark.substring(1),
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w300,
                                  color: Theme.of(context).primaryColor,
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
                                _i.product.productModel[0].toUpperCase() +
                                    _i.product.productModel.substring(1),
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
                _i.deleted
                    ? ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(primary: Colors.white),
                        icon: Icon(
                          Icons.restore_from_trash,
                          color: Colors.grey,
                        ),
                        label: Text(
                          'RESTORE',
                          style: TextStyle(color: Colors.grey),
                        ),
                        onPressed: _deleteItem,
                      )
                    : Container(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                          icon: Icon(Icons.delete, color: Colors.white),
                          label: Text(
                            'DELETE ITEM',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: _deleteItem,
                        ),
                      ),
              ],
            ),
          ),
        ),
      );
  }
}
