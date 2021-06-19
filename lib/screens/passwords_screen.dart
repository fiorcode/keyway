import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/error_helper.dart';
import '../providers/item_provider.dart';
import '../widgets/empty_items.dart';

class PasswordsListScreen extends StatefulWidget {
  static const routeName = '/passwords';

  @override
  _PasswordsListScreenState createState() => _PasswordsListScreenState();
}

class _PasswordsListScreenState extends State<PasswordsListScreen> {
  ItemProvider _item;
  Future _getPasswordsAsync;

  Future<void> _getPasswords() async => await _item.fetchPasswords();

  @override
  void didChangeDependencies() {
    _item = Provider.of<ItemProvider>(context);
    _getPasswordsAsync = _getPasswords();
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
        future: _getPasswordsAsync,
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
                    : DataTable(
                        columnSpacing: 8,
                        columns: [
                          DataColumn(
                              label: Center(child: Text('id')), numeric: true),
                          DataColumn(label: Text('pass_enc'), numeric: true),
                          DataColumn(label: Text('pass_iv'), numeric: true),
                          DataColumn(label: Text('str')),
                          DataColumn(
                              label:
                                  Expanded(child: Center(child: Text('hash')))),
                        ],
                        rows: _item.passwords
                            .map(
                              (p) => DataRow(
                                cells: [
                                  DataCell(Container(
                                    width: 16,
                                    child: Center(
                                        child: Text(p.passwordId.toString())),
                                  )),
                                  DataCell(Container(
                                      width: 92,
                                      child: Center(
                                          child: Text(
                                        p.passwordEnc,
                                        overflow: TextOverflow.ellipsis,
                                      )))),
                                  DataCell(Container(
                                      width: 92,
                                      child: Center(
                                          child: Text(
                                        p.passwordIv,
                                        overflow: TextOverflow.ellipsis,
                                      )))),
                                  DataCell(Center(child: Text(p.strength))),
                                  DataCell(Container(
                                      width: 92,
                                      child: Center(
                                          child: Text(
                                        p.hash,
                                        overflow: TextOverflow.ellipsis,
                                      )))),
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
