import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/helpers/error_helper.dart';
import 'package:keyway/widgets/empty_items.dart';

class ProductCveTableScreen extends StatefulWidget {
  static const routeName = '/product-cve-table';

  @override
  _ProductCveTableScreenState createState() => _ProductCveTableScreenState();
}

class _ProductCveTableScreenState extends State<ProductCveTableScreen> {
  late ItemProvider _item;
  Future<void>? _getProductCves;

  Future<void> _getProductCvesAsync() async => await _item.fetchProductCves();

  @override
  void initState() {
    _item = Provider.of<ItemProvider>(context, listen: false);
    _getProductCves = _getProductCvesAsync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text('product_cve table', style: TextStyle(color: Colors.grey)),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _getProductCves,
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
                return _item.productCves.length <= 0
                    ? EmptyItems()
                    : ListView.separated(
                        itemCount: _item.productCves.length,
                        itemBuilder: (ctx, i) => ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('fk_product_id: '),
                                  Text(
                                    _item.productCves[i].fkProductId.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('fk_cve_id: '),
                                  Text(
                                    _item.productCves[i].fkCveId.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('patched: '),
                                  Text(
                                    _item.productCves[i].patched.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
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
