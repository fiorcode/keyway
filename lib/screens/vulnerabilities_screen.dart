import 'package:flutter/material.dart';
import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/screens/products_without_cpe_screen.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/nist_provider.dart';

class VulnerabilitiesScreen extends StatefulWidget {
  static const routeName = '/vulnerabilites';

  @override
  _VulnerabilitiesScreenState createState() => _VulnerabilitiesScreenState();
}

class _VulnerabilitiesScreenState extends State<VulnerabilitiesScreen> {
  ItemProvider _item;
  NistProvider _nist;

  Future<void> _getCves;
  Future<void> _getProducts;

  Future<void> _getCvesAsync() => _item.fetchCves();

  Future<void> _getProductsAsync() => _item.fetchProducts();

  void _goTo(BuildContext context, String route) =>
      Navigator.of(context).pushNamed(route);

  @override
  void initState() {
    _item = Provider.of<ItemProvider>(context, listen: false);
    _nist = Provider.of<NistProvider>(context, listen: false);
    _getCves = _getCvesAsync();
    _getProducts = _getProductsAsync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color _primary = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: _primary),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: Future.wait([_getProducts, _getCves]),
            builder: (ctx, snap) {
              switch (snap.connectionState) {
                case ConnectionState.done:
                  if (snap.hasError)
                    return Center(child: Text('error'));
                  else {
                    int _pwncpe = _item.products
                        .where((p) => p.fkCpe23uriId != null)
                        .length;
                    return Column(
                      children: [
                        Container(
                          height: 128,
                          width: double.infinity,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              _item.cves.length.toString(),
                              style: TextStyle(
                                color: _item.cves.length > 0
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 96,
                          width: double.infinity,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              'vulnerabilities\n to check',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _item.cves.length > 0
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 128,
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          _item.products.length.toString(),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text('products'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(_pwncpe.toString()),
                                      ),
                                    ),
                                    Expanded(
                                      child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text('with CPE'),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () => _goTo(
                                          context,
                                          ProductsWithoutCpeScreen.routeName,
                                        ),
                                        child: Text('Search missing CPE\'s'),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  break;
                default:
                  return Center(child: Text('default'));
              }
            },
          ),
        ],
      ),
    );
  }
}
