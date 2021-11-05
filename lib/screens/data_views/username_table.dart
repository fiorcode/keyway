import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/helpers/error_helper.dart';
import 'package:keyway/widgets/empty_items.dart';

class UsernameTableScreen extends StatefulWidget {
  static const routeName = '/username-table';

  @override
  _UsernameTableScreenState createState() => _UsernameTableScreenState();
}

class _UsernameTableScreenState extends State<UsernameTableScreen> {
  late ItemProvider _item;
  Future? _getUsernames;

  Future<void> _getUsernamesAsync() async => await _item.fetchUsernames();

  @override
  void didChangeDependencies() {
    _item = Provider.of<ItemProvider>(context);
    _getUsernames = _getUsernamesAsync();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text('username table', style: TextStyle(color: Colors.grey)),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _getUsernames,
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
                    : ListView.separated(
                        itemCount: _item.usernames.length,
                        itemBuilder: (ctx, i) => ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('id: '),
                                  Text(
                                    _item.usernames[i].usernameId.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('username_enc: '),
                                  Expanded(
                                    child: Text(
                                      _item.usernames[i].usernameEnc,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('username_iv: '),
                                  Expanded(
                                    child: Text(
                                      _item.usernames[i].usernameIv,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('username_hash: '),
                                  Expanded(
                                    child: Text(
                                      _item.usernames[i].usernameHash,
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
            default:
              return Center(child: Text('default'));
          }
        },
      ),
    );
  }
}
