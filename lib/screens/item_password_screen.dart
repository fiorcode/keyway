import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/error_helper.dart';
// import '../providers/cripto_provider.dart';
import '../providers/item_provider.dart';
// import '../widgets/unlock_container.dart';
// import '../widgets/Cards/alpha_locked_card.dart';
// import '../widgets/Cards/alpha_unlocked_card.dart';
import '../widgets/empty_items.dart';
// import '../widgets/TextFields/search_bar_text_field.dart';

class ItemPasswordListScreen extends StatefulWidget {
  static const routeName = '/item-password';

  @override
  _ItemPasswordListScreenState createState() => _ItemPasswordListScreenState();
}

class _ItemPasswordListScreenState extends State<ItemPasswordListScreen> {
  ItemProvider _item;
  Future _getItemPasswordsAsync;

  Future<void> _getItemPasswords() async => await _item.fetchItemPasswords();

  @override
  void didChangeDependencies() {
    _item = Provider.of<ItemProvider>(context);
    _getItemPasswordsAsync = _getItemPasswords();
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
        future: _getItemPasswordsAsync,
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
                    : DataTable(
                        columnSpacing: 8,
                        columns: [
                          DataColumn(
                              label: Center(child: Text('ItemID')),
                              numeric: true),
                          DataColumn(label: Text('PassID'), numeric: true),
                          DataColumn(label: Text('lapse'), numeric: true),
                          DataColumn(label: Text('status')),
                          DataColumn(
                              label:
                                  Expanded(child: Center(child: Text('date')))),
                        ],
                        rows: _item.itemPasswords
                            .map(
                              (ip) => DataRow(
                                cells: [
                                  DataCell(Center(
                                      child: Text(ip.fkItemId.toString()))),
                                  DataCell(Center(
                                      child: Text(ip.fkPasswordId.toString()))),
                                  DataCell(Center(
                                      child:
                                          Text(ip.passwordLapse.toString()))),
                                  DataCell(
                                      Center(child: Text(ip.passwordStatus))),
                                  DataCell(
                                      Center(child: Text(ip.passwordDate))),
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
