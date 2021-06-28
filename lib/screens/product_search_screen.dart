import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/error_helper.dart';
import '../models/cpe.dart';
import '../widgets/empty_items.dart';
import '../models/product.dart';
import '../providers/nist_provider.dart';

class ProductSearchScreen extends StatefulWidget {
  static const routeName = '/product-search';

  ProductSearchScreen({this.product});

  final Product product;

  @override
  _ProductSearchScreenState createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  NistProvider _nist;
  Future<List<Cpe>> _getCpesAsync;

  @override
  void didChangeDependencies() {
    _nist = Provider.of<NistProvider>(context, listen: false);
    _getCpesAsync =
        _nist.getCpesByCpeMatch(trademark: widget.product.productTrademark);
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
        future: _getCpesAsync,
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
                return Stack(
                  children: [
                    snap.data.length <= 0
                        ? EmptyItems()
                        : ListView.builder(
                            padding: EdgeInsets.all(12.0),
                            itemCount: snap.data.length,
                            itemBuilder: (ctx, i) {
                              return ListTile(
                                title: Text(snap.data[i].titles[0].title),
                              );
                            },
                          ),
                  ],
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
