import 'package:flutter/material.dart';
import 'package:keyway/helpers/error_helper.dart';
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
  Future<void>? _getUsernames;
  late List<Username> _usernames;

  Future<void> _getUsernamesAsync() async {
    ItemProvider _ip = Provider.of<ItemProvider>(context, listen: false);
    _usernames = await _ip.fetchUsernames();
    CriptoProvider _cp = Provider.of<CriptoProvider>(context, listen: false);
    Future.forEach(_usernames, (dynamic u) => _cp.decryptUsername(u))
        .onError((error, st) => ErrorHelper.errorDialog(context, error));
  }

  Future<void> _deleteUsername(Username u) async {
    await Provider.of<ItemProvider>(context, listen: false)
        .deleteUsername(u)
        .onError((error, st) => ErrorHelper.errorDialog(context, error));
    _getUsernames = _getUsernamesAsync();
    setState(() {});
  }

  @override
  void initState() {
    _getUsernames = _getUsernamesAsync();
    super.initState();
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
          future: _getUsernames,
          builder: (ctx, snap) {
            switch (snap.connectionState) {
              case ConnectionState.waiting:
                return LoadingScaffold();
              case ConnectionState.done:
                return ListView.builder(
                    padding: EdgeInsets.all(12.0),
                    itemCount: _usernames.length,
                    itemBuilder: (ctx, i) {
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.account_box, size: 38),
                          title: Text(_usernames[i].usernameDec),
                          trailing: IconButton(
                            onPressed: () => _deleteUsername(_usernames[i]),
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
