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
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TextField(
                        autocorrect: true,
                        controller: widget.trademarkCtrler,
                        decoration: InputDecoration(hintText: 'Trademark'),
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
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: 32,
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
