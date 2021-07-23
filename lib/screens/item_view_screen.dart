import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cripto_provider.dart';
import '../models/item.dart';
import '../widgets/unlock_container.dart';
import '../widgets/item_view_container.dart';

class ItemViewScreen extends StatefulWidget {
  static const routeName = '/item-view';

  ItemViewScreen({this.item});

  final Item item;

  @override
  _ItemViewScreenState createState() => _ItemViewScreenState();
}

class _ItemViewScreenState extends State<ItemViewScreen> {
  CriptoProvider _cripto;
  bool _unlocking = false;

  void _lockSwitch() => setState(() => _unlocking = !_unlocking);

  @override
  void initState() {
    _cripto = Provider.of<CriptoProvider>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        centerTitle: true,
        title: _cripto.locked
            ? IconButton(
                icon: Icon(
                  Icons.lock_outline,
                  color: _unlocking ? Colors.orange : Colors.red,
                ),
                // onPressed: _cripto.locked ? _lockSwitch : null,
                onPressed: () => _cripto.unlock('Qwe123!'),
              )
            : Text(
                widget.item.title,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.item.username != null)
                    ItemViewContainer(
                      'username',
                      _cripto.decryptUsername(widget.item.username),
                    ),
                  if (widget.item.password != null)
                    ItemViewContainer(
                      'password',
                      _cripto.decryptPassword(widget.item.password),
                    ),
                  if (widget.item.pin != null)
                    ItemViewContainer(
                      'pin',
                      _cripto.decryptPin(widget.item.pin),
                    ),
                  if (widget.item.note != null)
                    ItemViewContainer(
                      'note',
                      _cripto.decryptNote(widget.item.note),
                    ),
                  if (widget.item.address != null)
                    Container(
                      width: double.infinity,
                      height: 92,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 3.0,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 4,
                                ),
                                color: Colors.black,
                                child: Text(
                                  widget.item.address.addressProtocol,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 4,
                                ),
                                color: Colors.black,
                                child: Text(
                                  'address',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 4,
                                ),
                                color: Colors.black,
                                child: Text(
                                  widget.item.address.addressPort.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                _cripto.decryptAddress(widget.item.address),
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w300,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (widget.item.product != null)
                    Container(
                      width: double.infinity,
                      height: 92,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 3.0,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 4,
                            ),
                            color: Colors.black,
                            child: Text(
                              'product',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                widget.item.product.productTrademark,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w300,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                widget.item.product.productModel,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w300,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (_unlocking && _cripto.locked) UnlockContainer(_lockSwitch),
        ],
      ),
    );
  }
}
