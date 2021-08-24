import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/cripto_provider.dart';
import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/models/username.dart';
import 'package:keyway/widgets/loading_scaffold.dart';

class UsernamesScreen extends StatefulWidget {
  static const routeName = '/usernames';

  @override
  _UsernamesScreenState createState() => _UsernamesScreenState();
}

class _UsernamesScreenState extends State<UsernamesScreen> {
  ItemProvider _item;
  Future<void> _getUsernames;

  Future<void> _getUsernamesAsync() => _item.fetchUsernames();

  Future<void> _deleteUsername(Username u) async {
    await _item.deleteUsername(u);
    _getUsernames = _getUsernamesAsync();
    setState(() {});
  }

  @override
  void initState() {
    _item = Provider.of<ItemProvider>(context, listen: false);
    _getUsernames = _getUsernamesAsync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CriptoProvider _cripto =
        Provider.of<CriptoProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: FutureBuilder(
          future: _getUsernames,
          builder: (ctx, snap) {
            switch (snap.connectionState) {
              case ConnectionState.waiting:
                return LoadingScaffold();
                break;
              case ConnectionState.done:
                return ListView.builder(
                    padding: EdgeInsets.all(12.0),
                    itemCount: _item.usernames.length,
                    itemBuilder: (ctx, i) {
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.account_box, size: 38),
                          title:
                              Text(_cripto.decryptUsername(_item.usernames[i])),
                          trailing: IconButton(
                            onPressed: () =>
                                _deleteUsername(_item.usernames[i]),
                            icon: Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                              size: 32,
                            ),
                          ),
                        ),
                      );
                    });
              default:
                return Text('default');
            }
          }),
    );
  }
}
