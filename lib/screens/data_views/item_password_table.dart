import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/helpers/error_helper.dart';
import 'package:keyway/widgets/empty_items.dart';

class ItemPasswordTableScreen extends StatefulWidget {
  static const routeName = '/item-password-table';

  @override
  _ItemPasswordTableScreenState createState() =>
      _ItemPasswordTableScreenState();
}

class _ItemPasswordTableScreenState extends State<ItemPasswordTableScreen> {
  late ItemProvider _item;
  Future<void>? _getItemPasswords;

  Future<void> _getItemPasswordsAsync() async =>
      await _item.fetchItemPasswords();

  @override
  void didChangeDependencies() {
    _item = Provider.of<ItemProvider>(context);
    _getItemPasswords = _getItemPasswordsAsync();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title:
            Text('item_password table', style: TextStyle(color: Colors.grey)),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _getItemPasswords,
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
                return _item.itemPasswords.length <= 0
                    ? EmptyItems()
                    : ListView.separated(
                        itemCount: _item.itemPasswords.length,
                        itemBuilder: (ctx, i) => ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('fk_item_id: '),
                                  Text(
                                    _item.itemPasswords[i].fkItemId.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('fk_password_id: '),
                                  Text(
                                    _item.itemPasswords[i].fkPasswordId
                                        .toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('password_lapse: '),
                                  Text(
                                    _item.itemPasswords[i].passwordLapse
                                        .toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('password_status: '),
                                  Text(
                                    _item.itemPasswords[i].passwordStatus,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('password_date: '),
                                  Expanded(
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        _item.itemPasswords[i].passwordDate!,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
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
