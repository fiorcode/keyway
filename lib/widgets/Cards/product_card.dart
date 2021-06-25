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
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            TextField(
              autocorrect: true,
              controller: widget.trademarkCtrler,
              decoration: InputDecoration(
                hintText: 'Trademark',
                // suffixIcon: _type == TextInputType.url
                //     ? IconButton(
                //         onPressed: _inputSwitch,
                //         icon: Icon(Icons.dialpad_outlined,
                //             color: Colors.grey),
                //       )
                //     : IconButton(
                //         onPressed: _inputSwitch,
                //         icon: Icon(Icons.keyboard_outlined,
                //             color: Colors.grey),
                //       ),
              ),
              textAlign: TextAlign.center,
              onChanged: (_) {},
            ),
            TextField(
              autocorrect: true,
              controller: widget.modelCtrler,
              decoration: InputDecoration(
                hintText: 'Model',
                // suffixIcon: _type == TextInputType.url
                //     ? IconButton(
                //         onPressed: _inputSwitch,
                //         icon: Icon(Icons.dialpad_outlined,
                //             color: Colors.grey),
                //       )
                //     : IconButton(
                //         onPressed: _inputSwitch,
                //         icon: Icon(Icons.keyboard_outlined,
                //             color: Colors.grey),
                //       ),
              ),
              textAlign: TextAlign.center,
              onChanged: (_) {},
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
            IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductSearchScreen()),
              ),
              icon: Icon(Icons.search),
            )
          ],
        ),
      ),
    );
  }
}
