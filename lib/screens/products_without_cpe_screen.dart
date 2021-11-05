import 'package:flutter/material.dart';
import 'package:keyway/screens/product_search_screen.dart';
import 'package:provider/provider.dart';

import 'package:keyway/models/product.dart';
import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/widgets/loading_scaffold.dart';

class ProductsWithoutCpeScreen extends StatefulWidget {
  static const routeName = 'products-without-cpe';

  @override
  _ProductsWithoutCpeScreenState createState() =>
      _ProductsWithoutCpeScreenState();
}

class _ProductsWithoutCpeScreenState extends State<ProductsWithoutCpeScreen> {
  late ItemProvider _item;
  Future<List<Product>>? _getProducts;

  Future<List<Product>> _getProductsAsync() => _item.getProductsWithNoCpe();

  void _goToSearch(
    BuildContext context,
    String route,
    Product? product,
    String? trademark,
    String? model,
  ) =>
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductSearchScreen(
            product: product,
            trademarkCtrler: TextEditingController(text: trademark),
            modelCtrler: TextEditingController(text: model),
          ),
        ),
      );

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
              case ConnectionState.done:
                List<Product> products = <Product>[];
                products = snap.data as List<Product>;
                return ListView.builder(
                    padding: EdgeInsets.all(12.0),
                    itemCount: products.length,
                    itemBuilder: (ctx, i) {
                      return Card(
                        child: ListTile(
                          leading: Icon(products[i].icon, size: 32),
                          title: Text(products[i].productTrademark),
                          subtitle: Text(products[i].productModel),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.chevron_right,
                              color: Colors.grey,
                              size: 32,
                            ),
                          ),
                          onTap: () => _goToSearch(
                            context,
                            ProductSearchScreen.routeName,
                            products[i],
                            products[i].productTrademark,
                            products[i].productModel,
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
