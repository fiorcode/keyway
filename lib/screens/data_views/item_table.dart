import 'package:flutter/material.dart';
import 'package:keyway/models/item.dart';
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
  Future? _getItems;
  late List<Item> _items;

  Future<void> _getItemsAsync() async => _items =
      await Provider.of<ItemProvider>(context, listen: false).fetchItems();

  @override
  void initState() {
    _items = <Item>[];
    _getItems = _getItemsAsync();
    super.initState();
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
                return _items.length <= 0
                    ? EmptyItems()
                    : ListView.separated(
                        itemCount: _items.length,
                        itemBuilder: (ctx, i) => ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('id: '),
                                  Text(
                                    _items[i].itemId.toString(),
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
                                    _items[i].title,
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
                                    _items[i].date,
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
                                    _items[i].avatarColor.toString(),
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
                                    _items[i].avatarLetterColor.toString(),
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
                                    _items[i].font!,
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
                                    _items[i].itemStatus!,
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
                                    _items[i].tags!,
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
                                    _items[i].fkUsernameId.toString(),
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
                                    _items[i].fkPinId.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('fk_note_id: '),
                                  Text(
                                    _items[i].fkNoteId.toString(),
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
                                    _items[i].fkAddressId.toString(),
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
                                    _items[i].fkProductId.toString(),
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
            default:
              return Center(child: Text('default'));
          }
        },
      ),
    );
  }
}
