import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:keyway/models/product.dart';

import '../helpers/error_helper.dart';
import '../models/cpe.dart';
import '../models/cpe_body.dart';
import '../widgets/empty_items.dart';

class ProductSearchScreen extends StatefulWidget {
  static const routeName = '/product-search';

  ProductSearchScreen({this.product});

  final Product product;

  @override
  _ProductSearchScreenState createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  List<Cpe> _cpes;
  Future _getCpesAsync;
  TextEditingController _searchCtrler;
  FocusNode _searchFocusNode;
  bool _searching = false;

  Future<void> _getCpes() async {
    CpeBody _body;
    final response = await http.get(Uri.parse(
        'https://services.nvd.nist.gov/rest/json/cpes/1.0?cpeMatchString=cpe:2.3:h:zte&resultsPerPage=50'));
    if (response.statusCode == 200) {
      final _bodyJson = jsonDecode(response.body);
      _body = CpeBody.fromJson(_bodyJson);
    }
    _cpes = _body.result.cpes;
  }

  void _searchSwitch() {
    setState(() {
      _searching = !_searching;
      _searching ? _searchFocusNode.requestFocus() : _searchFocusNode.unfocus();
      if (!_searching) _clearSearch();
    });
  }

  void _clearSearch() {
    _searchCtrler.clear();
    _getCpesAsync = _getCpes();
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    _searchCtrler = TextEditingController();
    _searchFocusNode = FocusNode();
    _getCpesAsync = _getCpes();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        centerTitle: true,
        title: _searching
            ? TextField(
                autocorrect: false,
                controller: _searchCtrler,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: InkWell(
                    child: Icon(Icons.search),
                    onTap: _searchSwitch,
                  ),
                ),
                onChanged: (_) {},
              )
            : IconButton(
                icon: Icon(Icons.search),
                onPressed: _searchSwitch,
              ),
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
                    _cpes.length <= 0
                        ? EmptyItems()
                        : ListView.builder(
                            padding: EdgeInsets.all(12.0),
                            itemCount: _cpes.length,
                            itemBuilder: (ctx, i) {
                              return ListTile(
                                title: Text(_cpes[i].titles[0].title),
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
