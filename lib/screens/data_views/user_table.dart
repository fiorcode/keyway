import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/helpers/error_helper.dart';
import 'package:keyway/models/user.dart';
import 'package:keyway/widgets/empty_items.dart';

class UserTableScreen extends StatefulWidget {
  static const routeName = '/user-table';

  @override
  _UserTableScreenState createState() => _UserTableScreenState();
}

class _UserTableScreenState extends State<UserTableScreen> {
  late ItemProvider _item;
  Future<List<User>>? _getUserData;

  Future<List<User>> _getUserDataAsync() => _item.getUserData();

  @override
  void initState() {
    _item = Provider.of<ItemProvider>(context, listen: false);
    _getUserData = _getUserDataAsync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text('user data table', style: TextStyle(color: Colors.grey)),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _getUserData,
        builder: (ctx, snap) {
          switch (snap.connectionState) {
            case ConnectionState.none:
              return Center(child: Text('none'));
            case (ConnectionState.waiting):
              return Center(child: CircularProgressIndicator());
            case (ConnectionState.done):
              if (snap.hasError)
                return ErrorHelper.errorBody(snap.error);
              else {
                List<User> _users = snap.data as List<User>;
                return _users.length <= 0
                    ? EmptyItems()
                    : ListView.separated(
                        itemCount: _users.length,
                        itemBuilder: (ctx, i) => ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('mk_enc: '),
                                  Expanded(
                                    child: Text(
                                      _users[i].encMk!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('mk_iv: '),
                                  Expanded(
                                    child: Text(
                                      _users[i].mkIv!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
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
              }
            default:
              return Center(child: Text('default'));
          }
        },
      ),
    );
  }
}
