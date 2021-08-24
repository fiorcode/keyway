import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/cripto_provider.dart';
import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/models/password.dart';
import 'package:keyway/widgets/loading_scaffold.dart';

class PasswordsScreen extends StatefulWidget {
  static const routeName = '/passwords';

  @override
  _PasswordsScreenState createState() => _PasswordsScreenState();
}

class _PasswordsScreenState extends State<PasswordsScreen> {
  ItemProvider _item;
  Future<void> _getPasswords;

  Future<void> _getPasswordsAsync() => _item.fetchPasswords();

  Future<void> _deletePassword(Password p) async {
    await _item.deletePassword(p);
    _getPasswords = _getPasswordsAsync();
    setState(() {});
  }

  @override
  void initState() {
    _item = Provider.of<ItemProvider>(context, listen: false);
    _getPasswords = _getPasswordsAsync();
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
          future: _getPasswords,
          builder: (ctx, snap) {
            switch (snap.connectionState) {
              case ConnectionState.waiting:
                return LoadingScaffold();
                break;
              case ConnectionState.done:
                return ListView.builder(
                    padding: EdgeInsets.all(12.0),
                    itemCount: _item.passwords.length,
                    itemBuilder: (ctx, i) {
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.password, size: 38),
                          title:
                              Text(_cripto.decryptPassword(_item.passwords[i])),
                          trailing: IconButton(
                            onPressed: () =>
                                _deletePassword(_item.passwords[i]),
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
