import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/error_helper.dart';
import '../providers/item_provider.dart';
import '../widgets/empty_items.dart';

class Cpe23uriCveListScreen extends StatefulWidget {
  static const routeName = '/cpe23uris-cve';

  @override
  _Cpe23uriCveListScreenState createState() => _Cpe23uriCveListScreenState();
}

class _Cpe23uriCveListScreenState extends State<Cpe23uriCveListScreen> {
  ItemProvider _item;
  Future _getCpe23uriCvesAsync;

  Future<void> _getCpe23uriCves() async => await _item.fetchCpe23uriCves();

  @override
  void didChangeDependencies() {
    _item = Provider.of<ItemProvider>(context);
    _getCpe23uriCvesAsync = _getCpe23uriCves();
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
        future: _getCpe23uriCvesAsync,
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
                return _item.cpe23uriCves.length <= 0
                    ? EmptyItems()
                    : DataTable(
                        columnSpacing: 8,
                        columns: [
                          DataColumn(label: Text('cpe23uri_id')),
                          DataColumn(label: Text('cve_id')),
                        ],
                        rows: _item.cpe23uriCves
                            .map(
                              (c) => DataRow(
                                cells: [
                                  DataCell(Container(
                                    width: 16,
                                    child: Center(
                                      child: Text(c.fkCpe23uriId.toString()),
                                    ),
                                  )),
                                  DataCell(
                                    Container(
                                      width: 92,
                                      child: Center(
                                        child: Text(c.fkCveId.toString()),
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
