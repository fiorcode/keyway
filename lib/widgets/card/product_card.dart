import 'package:flutter/material.dart';

import 'package:keyway/models/product.dart';
import 'package:keyway/screens/product_search_screen.dart';

class ProductCard extends StatefulWidget {
  const ProductCard(
    this.product,
    this.trademarkCtrler,
    this.modelCtrler,
  );

  final Product product;
  final TextEditingController trademarkCtrler;
  final TextEditingController modelCtrler;

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late bool _emptyTrademark;
  late bool _emptyModel;

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

  @override
  void initState() {
    _emptyTrademark = widget.trademarkCtrler.text.isEmpty;
    _emptyModel = widget.modelCtrler.text.isEmpty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12.0,
              children: [
                ChoiceChip(
                  backgroundColor: Colors.grey,
                  selected: widget.product.isHardware,
                  selectedColor: Colors.grey[200],
                  onSelected: (selected) => selected
                      ? setState(() => widget.product.setTypeHardware())
                      : setState(() => widget.product.setTypeAll()),
                  label: Text(
                    'Hardware',
                    style: TextStyle(
                      color: widget.product.isHardware
                          ? Colors.grey
                          : Colors.white,
                      fontWeight:
                          widget.product.isHardware ? FontWeight.bold : null,
                    ),
                  ),
                  elevation: widget.product.isHardware ? 8.0 : 0.0,
                ),
                ChoiceChip(
                  backgroundColor: Colors.grey,
                  selected: widget.product.isOsFirmware,
                  selectedColor: Colors.grey[200],
                  onSelected: (selected) => selected
                      ? setState(() => widget.product.setTypeOsFirmware())
                      : setState(() => widget.product.setTypeAll()),
                  label: Text(
                    'OS/Firmware',
                    style: TextStyle(
                      color: widget.product.isOsFirmware
                          ? Colors.grey
                          : Colors.white,
                      fontWeight:
                          widget.product.isOsFirmware ? FontWeight.bold : null,
                    ),
                  ),
                  elevation: widget.product.isOsFirmware ? 8.0 : 0.0,
                ),
                ChoiceChip(
                  backgroundColor: Colors.grey,
                  selected: widget.product.isApp,
                  selectedColor: Colors.grey[200],
                  onSelected: (selected) => selected
                      ? setState(() => widget.product.setTypeApp())
                      : setState(() => widget.product.setTypeAll()),
                  label: Text(
                    'App/Program',
                    style: TextStyle(
                      color: widget.product.isApp ? Colors.grey : Colors.white,
                      fontWeight: widget.product.isApp ? FontWeight.bold : null,
                    ),
                  ),
                  elevation: widget.product.isApp ? 8.0 : 0.0,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
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
                        onChanged: (value) => _onChangedTrademark(value),
                      ),
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
                        onChanged: (value) => _onChangedModel(value),
                      ),
                    ],
                  ),
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
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductSearchScreen(
                        product: widget.product,
                        trademarkCtrler: widget.trademarkCtrler,
                        modelCtrler: widget.modelCtrler,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
