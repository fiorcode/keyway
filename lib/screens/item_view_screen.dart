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
import '../widgets/loading_scaffold.dart';

class ItemViewScreen extends StatefulWidget {
  static const routeName = '/item-view';

  ItemViewScreen({this.item, this.onReturn});

  final Item item;
  final Function onReturn;

  @override
  _ItemViewScreenState createState() => _ItemViewScreenState();
}

class _ItemViewScreenState extends State<ItemViewScreen> {
  Item _i;
  Future<void> _loadItem;

  void _onReturn(Item i) {
    if (i != null) setState(() => _i = i);
    widget.onReturn();
  }

  Future<void> _loadItemAsync() async {
    ItemProvider _items = Provider.of<ItemProvider>(context, listen: false);
    await _items.loadPasswords(_i);
    CriptoProvider _c = Provider.of<CriptoProvider>(context, listen: false);
    _i = await _c.computeDecryptItem(_i);
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
    widget.onReturn();
  }

  @override
  void initState() {
    _i = widget.item;
    _loadItem = _loadItemAsync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color _back = Theme.of(context).backgroundColor;
    Color _primary = Theme.of(context).primaryColor;
    return FutureBuilder(
        future: _loadItem,
        builder: (ctx, snap) {
          switch (snap.connectionState) {
            case ConnectionState.waiting:
              return LoadingScaffold();
              break;
            case ConnectionState.done:
              if (snap.hasError)
                return ErrorBody(snap.error);
              else {
                return Scaffold(
                  backgroundColor: _back,
                  appBar: AppBar(
                    backgroundColor: _back,
                    iconTheme: IconThemeData(color: _primary),
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
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: _goToEditItem,
                      )
                    ],
                    actionsIconTheme: IconThemeData(color: _primary),
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
                              _i.username.usernameDec,
                            ),
                          if (_i.password != null)
                            ItemViewContainer(
                              'password',
                              _i.password.passwordDec,
                              left: _i.itemPassword.passwordDate,
                              right: _i.itemPassword.passwordLapse,
                            ),
                          if (_i.itemPasswords.isNotEmpty)
                            Center(
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
                          if (_i.pin != null)
                            ItemViewContainer(
                              'pin',
                              _i.pin.pinDec,
                              left: _i.pin.pinDate == null
                                  ? 'null'
                                  : _i.pin.pinDate,
                              right: _i.pin.pinLapse,
                            ),
                          if (_i.note != null)
                            ItemViewContainer('note', _i.note.noteDec),
                          if (_i.address != null)
                            ItemViewContainer(
                              'address',
                              _i.address.addressDec,
                              left: _i.address.addressProtocol,
                              right: _i.address.addressPort,
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
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
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
                                          _i.product.trademark,
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w300,
                                            color: _primary,
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
                                          _i.product.model,
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w300,
                                            color: _primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          _i.deleted
                              ? ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                  ),
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
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                    ),
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
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
              break;
            default:
              return LoadingScaffold();
          }
        });
  }
}
