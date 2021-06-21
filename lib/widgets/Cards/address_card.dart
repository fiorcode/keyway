import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddressCard extends StatefulWidget {
  const AddressCard(this.addressCtrler, this.portCtrler, this.refreshScreen,
      this.addressFocus, this.portFocus);

  final TextEditingController addressCtrler;
  final TextEditingController portCtrler;
  final Function refreshScreen;
  final FocusNode addressFocus;
  final FocusNode portFocus;

  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  TextInputType _type = TextInputType.url;

  void _inputSwitch() {
    FocusScope.of(context).unfocus();
    setState(() => _type == TextInputType.url
        ? _type = TextInputType.number
        : _type = TextInputType.url);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Container(
              width: 256,
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autocorrect: false,
                keyboardType: _type,
                controller: widget.addressCtrler,
                focusNode: widget.addressFocus,
                decoration: InputDecoration(
                  hintText: 'Address',
                ),
                maxLength: 128,
                textAlign: TextAlign.center,
                onChanged: (_) => widget.refreshScreen(),
              ),
            ),
            Container(
              width: 48,
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autocorrect: false,
                keyboardType: TextInputType.number,
                controller: widget.addressCtrler,
                focusNode: widget.addressFocus,
                decoration: InputDecoration(
                  hintText: 'Port',
                ),
                maxLength: 6,
                textAlign: TextAlign.center,
                onChanged: (_) => widget.refreshScreen(),
              ),
            ),
            _type == TextInputType.url
                ? IconButton(
                    onPressed: _inputSwitch,
                    icon: Icon(Icons.dialpad),
                  )
                : IconButton(
                    onPressed: _inputSwitch,
                    icon: Icon(Icons.keyboard),
                  ),
          ],
        ),
      ),
    );
  }
}
