import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/helpers/error_helper.dart';
import 'package:keyway/widgets/empty_items.dart';

class PasswordTableScreen extends StatefulWidget {
  static const routeName = '/password-table';

  @override
  _PasswordTableScreenState createState() => _PasswordTableScreenState();
}

class _PasswordTableScreenState extends State<PasswordTableScreen> {
  late ItemProvider _item;
  Future? _getPasswords;

  Future<void> _getPasswordsAsync() async =>
      await Provider.of<ItemProvider>(context, listen: false).fetchPasswords();

  @override
  void initState() {
    _getPasswords = _getPasswordsAsync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _item = Provider.of<ItemProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text('password table', style: TextStyle(color: Colors.grey)),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _getPasswords,
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
                return _item.passwords.length <= 0
                    ? EmptyItems()
                    : ListView.separated(
                        itemCount: _item.passwords.length,
                        itemBuilder: (ctx, i) => ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('id: '),
                                  Text(
                                    _item.passwords[i].passwordId.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('password_enc: '),
                                  Expanded(
                                    child: Text(
                                      _item.passwords[i].passwordEnc,
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
                                  Text('password_iv: '),
                                  Expanded(
                                    child: Text(
                                      _item.passwords[i].passwordIv,
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
                                  Text('password_strength: '),
                                  Expanded(
                                    child: Text(
                                      _item.passwords[i].passwordStrength,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('password_hash: '),
                                  Expanded(
                                    child: Text(
                                      _item.passwords[i].passwordHash,
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
