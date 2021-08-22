import 'package:flutter/material.dart';
import 'package:keyway/models/product.dart';

import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/widgets/loading_scaffold.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget {
  static const routeName = '/products';

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  ItemProvider _item;
  Future<void> _getProducts;

  Future<void> _getProductsAsync() => _item.fetchProducts();

  Future<void> _deleteProduct(Product p) async {
    await _item.deleteProduct(p);
    _getProducts = _getProductsAsync();
    setState(() {});
  }

  @override
  void initState() {
    _item = Provider.of<ItemProvider>(context, listen: false);
    _getProducts = _getProductsAsync();
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
          future: _getProducts,
          builder: (ctx, snap) {
            switch (snap.connectionState) {
              case ConnectionState.waiting:
                return LoadingScaffold();
                break;
              case ConnectionState.done:
                return ListView.builder(
                    padding: EdgeInsets.all(12.0),
                    itemCount: _item.products.length,
                    itemBuilder: (ctx, i) {
                      return Card(
                        child: ListTile(
                          leading: Icon(_item.products[i].icon, size: 32),
                          title: Text(_item.products[i].productTrademark),
                          subtitle: Text(_item.products[i].productModel),
                          trailing: IconButton(
                            onPressed: () => _deleteProduct(_item.products[i]),
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
