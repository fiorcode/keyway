import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/error_helper.dart';
import '../providers/item_provider.dart';
import '../widgets/empty_items.dart';

class DevicesListScreen extends StatefulWidget {
  static const routeName = '/devices';

  @override
  _DevicesListScreenState createState() => _DevicesListScreenState();
}

class _DevicesListScreenState extends State<DevicesListScreen> {
  ItemProvider _item;
  Future _getDevicesAsync;

  Future<void> _getDevices() async => await _item.fetchDevices();

  @override
  void didChangeDependencies() {
    _item = Provider.of<ItemProvider>(context);
    _getDevicesAsync = _getDevices();
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
        future: _getDevicesAsync,
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
                return _item.devices.length <= 0
                    ? EmptyItems()
                    : DataTable(
                        columnSpacing: 8,
                        columns: [
                          DataColumn(label: Text('id')),
                          DataColumn(label: Text('type')),
                          DataColumn(label: Text('vendor')),
                          DataColumn(label: Text('product')),
                          DataColumn(label: Text('version')),
                          DataColumn(label: Text('update')),
                          DataColumn(label: Text('cpe_id')),
                        ],
                        rows: _item.devices
                            .map(
                              (d) => DataRow(
                                cells: [
                                  DataCell(Container(
                                    width: 16,
                                    child: Center(
                                        child: Text(d.deviceId.toString())),
                                  )),
                                  DataCell(
                                    Container(
                                      width: 92,
                                      child: Center(
                                        child: Text(
                                          d.type,
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
                                          d.vendor,
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
                                          d.product,
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
                                          d.version,
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
                                          d.updateCode,
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
                                          d.fkCpe23uriId.toString(),
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
