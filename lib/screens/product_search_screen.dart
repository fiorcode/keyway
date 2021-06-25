import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keyway/models/cpe23uri.dart';

import 'package:http/http.dart' as http;

import '../helpers/error_helper.dart';
import '../widgets/empty_items.dart';

class ProductSearchScreen extends StatefulWidget {
  static const routeName = '/product-search';

  @override
  _ProductSearchScreenState createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  List<Cpe23uri> _cpes;
  Future _getCpesAsync;
  TextEditingController _searchCtrler;
  FocusNode _searchFocusNode;
  bool _searching = false;

  Future<List<Cpe23uri>> _getCpes() async {
    final response = await http.get(Uri.parse(
        'https://services.nvd.nist.gov/rest/json/cpes/1.0?cpeMatchString=cpe:2.3:h:zte&resultsPerPage=100'));
    if (response.statusCode == 200) {
      final i = jsonDecode(response.body);
      _cpes = List<Cpe23uri>.from(i.map((e) => Cpe23uri.fromMap(e)));
    }
    return _cpes;
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
                                title: Text(_cpes[i].title),
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
