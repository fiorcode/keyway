import 'package:flutter/material.dart';
import 'package:keyway/helpers/error_helper.dart';
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
  Future<void>? _getPasswords;
  late List<Password> _passwords;

  Future<void> _getPasswordsAsync() async {
    ItemProvider _ip = Provider.of<ItemProvider>(context, listen: false);
    _passwords = await _ip.fetchPasswords();
    CriptoProvider _cp = Provider.of<CriptoProvider>(context, listen: false);
    Future.forEach(_passwords, (dynamic p) => _cp.decryptPassword(p));
  }

  Future<void> _deletePassword(Password p) async {
    ItemProvider _ip = Provider.of<ItemProvider>(context, listen: false);
    await _ip
        .deletePassword(p)
        .onError((error, st) => ErrorHelper.errorDialog(context, error));
    _getPasswords = _getPasswordsAsync();
    setState(() {});
  }

  @override
  void initState() {
    _getPasswords = _getPasswordsAsync();
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
          future: _getPasswords,
          builder: (ctx, snap) {
            switch (snap.connectionState) {
              case ConnectionState.waiting:
                return LoadingScaffold();
              case ConnectionState.done:
                return ListView.builder(
                    padding: EdgeInsets.all(12.0),
                    itemCount: _passwords.length,
                    itemBuilder: (ctx, i) {
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.password, size: 38),
                          title: Text(_passwords[i].passwordDec),
                          trailing: IconButton(
                            onPressed: () => _deletePassword(_passwords[i]),
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
