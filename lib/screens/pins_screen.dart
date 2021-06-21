import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/error_helper.dart';
import '../providers/item_provider.dart';
import '../widgets/empty_items.dart';

class PinsListScreen extends StatefulWidget {
  static const routeName = '/pins';

  @override
  _PinsListScreenState createState() => _PinsListScreenState();
}

class _PinsListScreenState extends State<PinsListScreen> {
  ItemProvider _item;
  Future _getPinsAsync;

  Future<void> _getPins() async => await _item.fetchPins();

  @override
  void didChangeDependencies() {
    _item = Provider.of<ItemProvider>(context);
    _getPinsAsync = _getPins();
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
        future: _getPinsAsync,
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
                return _item.pins.length <= 0
                    ? EmptyItems()
                    : DataTable(
                        columnSpacing: 8,
                        columns: [
                          DataColumn(
                              label: Center(child: Text('id')), numeric: true),
                          DataColumn(label: Text('pin_enc'), numeric: true),
                          DataColumn(label: Text('pin_iv'), numeric: true),
                          DataColumn(label: Text('pin_date')),
                          DataColumn(label: Text('lapse')),
                          DataColumn(
                              label: Expanded(
                                  child: Center(child: Text('status')))),
                        ],
                        rows: _item.pins
                            .map(
                              (p) => DataRow(
                                cells: [
                                  DataCell(
                                    Container(
                                      width: 16,
                                      child: Center(
                                        child: Text(p.pinId.toString()),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      width: 92,
                                      child: Center(
                                        child: Text(
                                          p.pinEnc,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      width: 92,
                                      child: Center(
                                        child: Text(
                                          p.pinIv,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        p.pinDate,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      width: 92,
                                      child: Center(
                                        child: Text(
                                          p.pinLapse.toString(),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      width: 92,
                                      child: Center(
                                        child: Text(
                                          p.pinStatus,
                                          overflow: TextOverflow.ellipsis,
                                        ),
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
