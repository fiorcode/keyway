import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  const ProductCard(
    this.trademarkCtrler,
    this.modelCtrler,
  );

  final TextEditingController trademarkCtrler;
  final TextEditingController modelCtrler;

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
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
          ],
        ),
      ),
    );
  }
}
