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
  void _trackSwitch() => setState(() => widget.product.trackSwitch());

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
                  selected: widget.product.productType == 'h',
                  selectedColor: Colors.grey[200],
                  onSelected: (selected) => selected
                      ? setState(() => widget.product.productType = 'h')
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
                  elevation: widget.product.productType == 'h' ? 8.0 : 0.0,
                ),
                ChoiceChip(
                  backgroundColor: Colors.grey,
                  selected: widget.product.productType == 'o',
                  selectedColor: Colors.grey[200],
                  onSelected: (selected) => selected
                      ? setState(() => widget.product.productType = 'o')
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
                  elevation: widget.product.productType == 'o' ? 8.0 : 0.0,
                ),
                ChoiceChip(
                  backgroundColor: Colors.grey,
                  selected: widget.product.productType == 'a',
                  selectedColor: Colors.grey[200],
                  onSelected: (selected) =>
                      setState(() => widget.product.productType = 'a'),
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
                  elevation: widget.product.productType == 'a' ? 8.0 : 0.0,
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
                        decoration:
                            InputDecoration(hintText: 'Trademark / Developer'),
                        textAlign: TextAlign.center,
                        onChanged: (value) =>
                            widget.product.productTrademark = value,
                      ),
                      TextField(
                        autocorrect: true,
                        controller: widget.modelCtrler,
                        decoration:
                            InputDecoration(hintText: 'Model / Program'),
                        textAlign: TextAlign.center,
                        onChanged: (value) =>
                            widget.product.productModel = value,
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
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    'Track vulnerabilities',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                Switch(
                  activeColor: Colors.green,
                  value: widget.product.tracked,
                  onChanged: (_) => _trackSwitch(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
