import 'package:flutter/material.dart';
import 'package:keyway/helpers/error_helper.dart';
import 'package:provider/provider.dart';

import '../providers/nist_provider.dart';
import '../models/product.dart';
import '../models/api/nist/cpe_body.dart';
import '../models/api/nist/cpe.dart';
import '../widgets/card/cpe_selection_card.dart';

class ProductSearchScreen extends StatefulWidget {
  static const routeName = '/product-search';

  ProductSearchScreen({this.product, this.trademarkCtrler, this.modelCtrler});

  final Product? product;
  final TextEditingController? trademarkCtrler;
  final TextEditingController? modelCtrler;

  @override
  _ProductSearchScreenState createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  Future<CpeBody>? _getCpesAsync;
  Product _product = Product();

  TextEditingController _trademarkCtrler = TextEditingController();
  TextEditingController _modelCtrler = TextEditingController();
  TextEditingController _keywordCtrler = TextEditingController();

  bool _emptyTrademark = true;
  bool _emptyModel = true;
  bool _emptyKeyword = true;

  bool _byKeyword = false;
  int _typeIndex = 0;

  bool _productNotEmpty() {
    if (_product.productTrademark.isNotEmpty) return true;
    if (_product.productModel.isNotEmpty) return true;
    return false;
  }

  void _onChangedTrademark(String value) {
    setState(() {
      _emptyTrademark = _trademarkCtrler.text.isEmpty;
      _product.productTrademark = value;
    });
  }

  void _clearTrademark() {
    setState(() {
      _trademarkCtrler.clear();
      _product.productTrademark = '';
      _emptyTrademark = true;
    });
  }

  void _onChangedModel(String value) {
    setState(() {
      _emptyModel = _modelCtrler.text.isEmpty;
      _product.productModel = value;
    });
  }

  void _clearModel() {
    setState(() {
      _modelCtrler.clear();
      _product.productModel = '';
      _emptyModel = true;
    });
  }

  void _onChangedKeyword(String value) {
    setState(() {
      _emptyKeyword = _keywordCtrler.text.isEmpty;
    });
  }

  void _clearKeyword() {
    setState(() {
      _keywordCtrler.clear();
      _emptyKeyword = true;
    });
  }

  void _searchTap({int index = 0}) {
    _search(startIndex: index);
    setState(() {});
  }

  void _search({int startIndex = 0}) {
    NistProvider _nist = Provider.of<NistProvider>(context, listen: false);
    if (_byKeyword) {
      if (_keywordCtrler.text.isEmpty) return;
      _getCpesAsync = _nist
          .getCpesByKeyword(
            _keywordCtrler.text,
            startIndex: startIndex,
          )
          .onError((error, st) => ErrorHelper.errorDialog(context, error));
    } else {
      if (_productNotEmpty()) {
        _getCpesAsync = _nist
            .getCpesByCpeMatch(
              type: _product.productType,
              trademark: _product.productTrademark,
              model: _product.productModel,
              startIndex: startIndex,
            )
            .onError((error, st) => ErrorHelper.errorDialog(context, error));
      }
    }
  }

  void _byKeywordSwitch() => setState(() => _byKeyword = !_byKeyword);

  void _typeSwitch() {
    if (_typeIndex == 3)
      _typeIndex = 0;
    else
      _typeIndex += 1;
    switch (_typeIndex) {
      case 1:
        _product.setTypeHardware();
        break;
      case 2:
        _product.setTypeOsFirmware();
        break;
      case 3:
        _product.setTypeApp();
        break;
      default:
        _product.setTypeAll();
    }
    setState(() {});
  }

  int _pages(int totalResults) => (totalResults.toDouble() / 100).ceil();

  void _setCpe(Cpe cpe) {
    _product.setCpe23uri(cpe);
    _product.productTrademark = cpe.trademark;
    _product.productModel = cpe.model;
    widget.trademarkCtrler!.text = cpe.trademark;
    widget.modelCtrler!.text = cpe.model;
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    if (widget.product != null) _product = widget.product!;
    if (widget.trademarkCtrler != null)
      _trademarkCtrler = widget.trademarkCtrler!;
    if (widget.modelCtrler != null) _modelCtrler = widget.modelCtrler!;
    _emptyTrademark = _trademarkCtrler.text.isEmpty;
    _emptyModel = _modelCtrler.text.isEmpty;
    _emptyKeyword = _keywordCtrler.text.isEmpty;
    _search();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color _back = Theme.of(context).backgroundColor;
    Color _primary = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: _back,
      appBar: AppBar(
        backgroundColor: _back,
        iconTheme: IconThemeData(color: _primary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Card(
              color: Colors.white,
              elevation: 4,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  children: [
                    if (!_byKeyword)
                      Row(
                        children: [
                          Text(
                            'Type',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ChoiceChip(
                              backgroundColor: Colors.grey,
                              selected: true,
                              selectedColor: Colors.grey[200],
                              onSelected: (_) {},
                              label: Text(
                                _product.type,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              elevation: 8.0,
                            ),
                          ),
                          IconButton(
                            onPressed: _typeSwitch,
                            icon: Icon(
                              Icons.change_circle_outlined,
                              color: Colors.grey,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                    if (!_byKeyword)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Trademark',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              autocorrect: true,
                              controller: _trademarkCtrler,
                              decoration: InputDecoration(
                                hintText: 'Trademark / Developer',
                                suffixIcon: _emptyTrademark
                                    ? null
                                    : InkWell(
                                        child: Icon(Icons.clear),
                                        onTap: _clearTrademark,
                                      ),
                              ),
                              textAlign: TextAlign.center,
                              onChanged: (value) => _onChangedTrademark(value),
                            ),
                          ),
                        ],
                      ),
                    if (!_byKeyword)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Model',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              autocorrect: true,
                              controller: _modelCtrler,
                              decoration: InputDecoration(
                                hintText: 'Model / Program',
                                suffixIcon: _emptyModel
                                    ? null
                                    : InkWell(
                                        child: Icon(Icons.clear),
                                        onTap: _clearModel,
                                      ),
                              ),
                              textAlign: TextAlign.center,
                              onChanged: (value) => _onChangedModel(value),
                            ),
                          ),
                        ],
                      ),
                    if (_byKeyword)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Keyword',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              autocorrect: true,
                              controller: _keywordCtrler,
                              decoration: InputDecoration(
                                hintText: 'Keyword',
                                suffixIcon: _emptyKeyword
                                    ? null
                                    : InkWell(
                                        child: Icon(Icons.clear),
                                        onTap: _clearKeyword,
                                      ),
                              ),
                              textAlign: TextAlign.center,
                              onChanged: (value) => _onChangedKeyword(value),
                            ),
                          ),
                        ],
                      ),
                    TextButton(
                      onPressed: _byKeywordSwitch,
                      child: Text(
                        _byKeyword
                            ? 'Search by Trademark/Model'
                            : 'Search by keyword',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.search, color: Colors.grey, size: 32),
                      label: Text('Search', textAlign: TextAlign.center),
                      onPressed: _searchTap,
                    ),
                  ],
                ),
              ),
            ),
            FutureBuilder(
              future: _getCpesAsync,
              builder: (ctx, snap) {
                switch (snap.connectionState) {
                  case ConnectionState.none:
                    return Center(child: Text('none'));
                  case (ConnectionState.waiting):
                    return Center(child: CircularProgressIndicator());
                  case (ConnectionState.done):
                    if (snap.hasError) {
                      return Text(snap.error.toString());
                    } else {
                      CpeBody body = snap.data as CpeBody;
                      return body.result!.cpes!.length <= 0
                          ? Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Center(
                                child: Image.asset(
                                  'assets/empty.png',
                                  width: MediaQuery.of(context).size.width * .3,
                                  color: Colors.black54,
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    '${body.totalResults} results',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                                if (body.totalResults! > 100)
                                  Container(
                                    height: 64,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12.0),
                                      itemCount: _pages(body.totalResults!),
                                      itemBuilder: (ctx, i) {
                                        return FloatingActionButton(
                                          elevation: body.startIndex! / 100 == i
                                              ? 8.0
                                              : 0.0,
                                          backgroundColor:
                                              body.startIndex! / 100 == i
                                                  ? Colors.white
                                                  : Colors.grey,
                                          onPressed: () =>
                                              _searchTap(index: i * 100),
                                          heroTag: null,
                                          child: Text(
                                            (i + 1).toString(),
                                            style: TextStyle(
                                              color: body.startIndex! / 100 == i
                                                  ? Colors.grey
                                                  : Colors.white,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: body.result!.cpes!.length,
                                  itemBuilder: (ctx, i) {
                                    return CpeSelectionCard(
                                      body.result!.cpes![i],
                                      _setCpe,
                                    );
                                  },
                                ),
                              ],
                            );
                    }
                  default:
                    return Center(child: Text('default'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
