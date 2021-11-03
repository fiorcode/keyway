import 'package:flutter/material.dart';
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
  late NistProvider _nist;
  Future<CpeBody>? _getCpesAsync;
  TextEditingController _keywordCtrler = TextEditingController();

  late bool _emptyTrademark;
  late bool _emptyModel;
  late bool _emptyKeyword;
  bool _byKeyword = false;
  int _typeIndex = 0;

  bool _productNotEmpty() {
    if (widget.product!.productTrademark!.isNotEmpty) return true;
    if (widget.product!.productModel!.isNotEmpty) return true;
    return false;
  }

  void _onChangedTrademark(String value) {
    setState(() {
      _emptyTrademark = widget.trademarkCtrler!.text.isEmpty;
      widget.product!.productTrademark = value;
    });
  }

  void _clearTrademark() {
    setState(() {
      widget.trademarkCtrler!.clear();
      widget.product!.productTrademark = '';
      _emptyTrademark = true;
    });
  }

  void _onChangedModel(String value) {
    setState(() {
      _emptyModel = widget.modelCtrler!.text.isEmpty;
      widget.product!.productModel = value;
    });
  }

  void _clearModel() {
    setState(() {
      widget.modelCtrler!.clear();
      widget.product!.productModel = '';
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
    _nist = Provider.of<NistProvider>(context, listen: false);
    if (_byKeyword) {
      if (_keywordCtrler.text.isEmpty) return;
      _getCpesAsync = _nist.getCpesByKeyword(
        _keywordCtrler.text,
        startIndex: startIndex,
      );
    } else {
      if (_productNotEmpty()) {
        _getCpesAsync = _nist.getCpesByCpeMatch(
          type: widget.product!.productType,
          trademark: widget.product!.productTrademark!,
          model: widget.product!.productModel!,
          startIndex: startIndex,
        );
      }
    }
  }

  void _byKeywordSwitch() => setState(() => _byKeyword = !_byKeyword);

  void _typeSwitch() {
    setState(() {
      if (_typeIndex == 3)
        _typeIndex = 0;
      else
        _typeIndex += 1;
      switch (_typeIndex) {
        case 1:
          widget.product!.productType = 'h';
          break;
        case 2:
          widget.product!.productType = 'o';
          break;
        case 3:
          widget.product!.productType = 'a';
          break;
        default:
          widget.product!.productType = '';
      }
    });
  }

  int _pages(int totalResults) => (totalResults.toDouble() / 100).ceil();

  void _setCpe(Cpe cpe) => widget.product!.setCpe23uri(cpe);

  @override
  void initState() {
    _emptyTrademark = widget.trademarkCtrler!.text.isEmpty;
    _emptyModel = widget.modelCtrler!.text.isEmpty;
    _emptyKeyword = _keywordCtrler.text.isEmpty;
    _search();
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
                                widget.product!.type,
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
                            icon: Icon(Icons.change_circle_outlined,
                                color: Colors.grey, size: 32),
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
