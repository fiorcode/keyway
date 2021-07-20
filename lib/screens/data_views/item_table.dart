import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/helpers/error_helper.dart';
import 'package:keyway/widgets/empty_items.dart';

class ItemTableScreen extends StatefulWidget {
  static const routeName = '/item-table';

  @override
  _ItemTableScreenState createState() => _ItemTableScreenState();
}

class _ItemTableScreenState extends State<ItemTableScreen> {
  ItemProvider _item;
  Future _getItems;

  Future<void> _getItemsAsync() async => await _item.fetchAllItems('');

  @override
  void didChangeDependencies() {
    _item = Provider.of<ItemProvider>(context);
    _getItems = _getItemsAsync();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text('item table', style: TextStyle(color: Colors.grey)),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _getItems,
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
                return _item.allItems.length <= 0
                    ? EmptyItems()
                    : ListView.separated(
                        itemCount: _item.allItems.length,
                        itemBuilder: (ctx, i) => ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('id: '),
                                  Text(
                                    _item.items[i].itemId.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('title: '),
                                  Text(
                                    _item.items[i].title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('date: '),
                                  Text(
                                    _item.items[i].date,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('avatar_color: '),
                                  Text(
                                    _item.items[i].avatarColor.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('avatar_letter_color: '),
                                  Text(
                                    _item.items[i].avatarLetterColor.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('font: '),
                                  Text(
                                    _item.items[i].font,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('item_status: '),
                                  Text(
                                    _item.items[i].itemStatus,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('tags: '),
                                  Text(
                                    _item.items[i].tags,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('fk_username_id: '),
                                  Text(
                                    _item.items[i].fkUsernameId.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('fk_pin_id: '),
                                  Text(
                                    _item.items[i].fkPinId.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('fk_long_text_id: '),
                                  Text(
                                    _item.items[i].fkLongTextId.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('fk_address_id: '),
                                  Text(
                                    _item.items[i].fkAddressId.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('fk_product_id: '),
                                  Text(
                                    _item.items[i].fkProductId.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        separatorBuilder: (ctx, i) =>
                            Divider(color: Colors.black),
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
