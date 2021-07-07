import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/error_helper.dart';
import '../providers/item_provider.dart';
import '../widgets/empty_items.dart';

class DevicesListScreen extends StatefulWidget {
  static const routeName = '/products';

  @override
  _DevicesListScreenState createState() => _DevicesListScreenState();
}

class _DevicesListScreenState extends State<DevicesListScreen> {
  ItemProvider _item;
  Future _getDevicesAsync;

  Future<void> _getDevices() async => await _item.fetchProducts();

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
                return _item.products.length <= 0
                    ? EmptyItems()
                    : DataTable(
                        columnSpacing: 8,
                        columns: [
                          DataColumn(label: Text('id')),
                          DataColumn(label: Text('type')),
                          DataColumn(label: Text('trademark')),
                          DataColumn(label: Text('model')),
                          DataColumn(label: Text('v')),
                          DataColumn(label: Text('u')),
                          DataColumn(label: Text('ps')),
                        ],
                        rows: _item.products
                            .map(
                              (p) => DataRow(
                                cells: [
                                  DataCell(
                                    Container(
                                      width: 16,
                                      child: Center(
                                          child: Text(p.productId.toString())),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      width: 92,
                                      child: Center(
                                        child: Text(
                                          p.productType,
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
                                          p.productTrademark,
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
                                          p.productModel,
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
                                          p.productVersion,
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
                                          p.productUpdate,
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
                                          p.productStatus,
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
