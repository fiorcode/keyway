import 'package:flutter/material.dart';
import 'package:keyway/widgets/Cards/cpe_selection_card.dart';
import 'package:provider/provider.dart';

import '../helpers/error_helper.dart';
import '../providers/nist_provider.dart';
import '../models/product.dart';
import '../models/cpe_body.dart';

class ProductSearchScreen extends StatefulWidget {
  static const routeName = '/product-search';

  ProductSearchScreen({this.product, this.trademarkCtrler, this.modelCtrler});

  final Product product;
  final TextEditingController trademarkCtrler;
  final TextEditingController modelCtrler;

  @override
  _ProductSearchScreenState createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  NistProvider _nist;
  Future<CpeBody> _getCpesAsync;
  TextEditingController _keywordCtrler;

  bool _emptyTrademark;
  bool _emptyModel;
  bool _emptyKeyword;
  bool _byKeyword = false;

  bool _productNotEmpty() {
    if (widget.product.productTrademark.isNotEmpty) return true;
    if (widget.product.productModel.isNotEmpty) return true;
    return false;
  }

  void _onChangedTrademark(String value) {
    setState(() {
      _emptyTrademark = widget.trademarkCtrler.text.isEmpty;
      widget.product.productTrademark = value;
    });
  }

  void _clearTrademark() {
    setState(() {
      widget.trademarkCtrler.clear();
      widget.product.productTrademark = '';
      _emptyTrademark = true;
    });
  }

  void _onChangedModel(String value) {
    setState(() {
      _emptyModel = widget.modelCtrler.text.isEmpty;
      widget.product.productModel = value;
    });
  }

  void _clearModel() {
    setState(() {
      widget.modelCtrler.clear();
      widget.product.productModel = '';
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

  void _byKeywordSwitch() {
    _clearTrademark();
    _clearModel();
    _clearKeyword();
    setState(() => _byKeyword = !_byKeyword);
  }

  void _search() {
    if (_byKeyword) {
      if (_keywordCtrler.text.isEmpty) return;
      setState(() {
        _getCpesAsync = _nist.getCpesByKeyword(_keywordCtrler.text);
      });
    } else {
      if (_productNotEmpty()) {
        setState(() {
          _getCpesAsync = _nist.getCpesByCpeMatch(
            type: widget.product.productType,
            trademark: widget.product.productTrademark,
            model: widget.product.productModel,
          );
        });
      }
    }
  }

  @override
  void initState() {
    _nist = Provider.of<NistProvider>(context, listen: false);
    _keywordCtrler = TextEditingController();
    _emptyTrademark = widget.trademarkCtrler.text.isEmpty;
    _emptyModel = widget.modelCtrler.text.isEmpty;
    _emptyKeyword = _keywordCtrler.text.isEmpty;
    if (_productNotEmpty()) {
      _getCpesAsync = _nist.getCpesByCpeMatch(
        type: widget.product.productType,
        trademark: widget.product.productTrademark,
        model: widget.product.productModel,
      );
    }
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
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 12.0,
                        children: [
                          ChoiceChip(
                            backgroundColor: Colors.grey,
                            selected: widget.product.productType == 'h',
                            selectedColor: Colors.grey[200],
                            onSelected: (selected) => selected
                                ? setState(
                                    () => widget.product.productType = 'h')
                                : null,
                            label: Text(
                              'Hardware',
                              style: TextStyle(
                                color: widget.product.productType == 'h'
                                    ? Colors.grey
                                    : Colors.white,
                                fontWeight: widget.product.productType == 'h'
                                    ? FontWeight.bold
                                    : null,
                              ),
                            ),
                            elevation:
                                widget.product.productType == 'h' ? 8.0 : 0.0,
                          ),
                          ChoiceChip(
                            backgroundColor: Colors.grey,
                            selected: widget.product.productType == 'o',
                            selectedColor: Colors.grey[200],
                            onSelected: (selected) => selected
                                ? setState(
                                    () => widget.product.productType = 'o')
                                : null,
                            label: Text(
                              'OS/Firmware',
                              style: TextStyle(
                                color: widget.product.productType == 'o'
                                    ? Colors.grey
                                    : Colors.white,
                                fontWeight: widget.product.productType == 'o'
                                    ? FontWeight.bold
                                    : null,
                              ),
                            ),
                            elevation:
                                widget.product.productType == 'o' ? 8.0 : 0.0,
                          ),
                          ChoiceChip(
                            backgroundColor: Colors.grey,
                            selected: widget.product.productType == 'a',
                            selectedColor: Colors.grey[200],
                            onSelected: (selected) => setState(
                                () => widget.product.productType = 'a'),
                            label: Text(
                              'App/Program',
                              style: TextStyle(
                                color: widget.product.productType == 'a'
                                    ? Colors.grey
                                    : Colors.white,
                                fontWeight: widget.product.productType == 'a'
                                    ? FontWeight.bold
                                    : null,
                              ),
                            ),
                            elevation:
                                widget.product.productType == 'a' ? 8.0 : 0.0,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                if (!_byKeyword)
                                  TextField(
                                    autocorrect: true,
                                    controller: widget.trademarkCtrler,
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
                                    onChanged: (value) =>
                                        _onChangedTrademark(value),
                                  ),
                                if (!_byKeyword)
                                  TextField(
                                    autocorrect: true,
                                    controller: widget.modelCtrler,
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
                                    onChanged: (value) =>
                                        _onChangedModel(value),
                                  ),
                                if (_byKeyword)
                                  TextField(
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
                                    onChanged: (value) =>
                                        _onChangedKeyword(value),
                                  ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: _byKeywordSwitch,
                            child: Text(
                              !_byKeyword
                                  ? 'Search by\nkeyword'
                                  : 'Search by\ntrademark\nor\nmodel',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextButton.icon(
                        icon: Icon(
                          Icons.search,
                          color: Colors.grey,
                          size: 32,
                        ),
                        label: Text(
                          'Find CPE',
                          textAlign: TextAlign.center,
                        ),
                        onPressed: _search,
                      ),
                    ],
                  ),
                ),
              ),
              if (_getCpesAsync != null)
                FutureBuilder(
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
                          return snap.data.result.cpes.length <= 0
                              ? Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/empty.png',
                                      width: MediaQuery.of(context).size.width *
                                          .3,
                                      color: Colors.black54,
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    Text(
                                        'Total results: ${snap.data.totalResults}'),
                                    ListView.builder(
                                      padding: EdgeInsets.all(12.0),
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: snap.data.result.cpes.length,
                                      itemBuilder: (ctx, i) {
                                        return CpeSelectionCard(
                                            snap.data.result.cpes[i]);
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
            ],
          ),
        ));
  }
}
