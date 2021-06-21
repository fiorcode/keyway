import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/error_helper.dart';
import '../providers/item_provider.dart';
import '../widgets/empty_items.dart';

class UsernamesListScreen extends StatefulWidget {
  static const routeName = '/usernames';

  @override
  _UsernamesListScreenState createState() => _UsernamesListScreenState();
}

class _UsernamesListScreenState extends State<UsernamesListScreen> {
  ItemProvider _item;
  Future _getUsernamesAsync;

  Future<void> _getUsernames() async => await _item.fetchUsernames();

  @override
  void didChangeDependencies() {
    _item = Provider.of<ItemProvider>(context);
    _getUsernamesAsync = _getUsernames();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: FutureBuilder(
        future: _getUsernamesAsync,
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
                return _item.usernames.length <= 0
                    ? EmptyItems()
                    : DataTable(
                        columnSpacing: 8,
                        columns: [
                          DataColumn(
                              label: Center(child: Text('id')), numeric: true),
                          DataColumn(label: Text('user_enc'), numeric: true),
                          DataColumn(label: Text('user_iv'), numeric: true),
                          DataColumn(label: Text('user_hash')),
                        ],
                        rows: _item.usernames
                            .map(
                              (u) => DataRow(
                                cells: [
                                  DataCell(Container(
                                    width: 16,
                                    child: Center(
                                        child: Text(u.usernameId.toString())),
                                  )),
                                  DataCell(
                                    Container(
                                      width: 92,
                                      child: Center(
                                        child: Text(
                                          u.usernameEnc,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      width: 92,
                                      child: Center(
                                        child: Text(
                                          u.usernameIv,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      width: 92,
                                      child: Center(
                                        child: Text(
                                          u.usernameHash == null
                                              ? ''
                                              : u.usernameHash,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
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
