import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cripto_provider.dart';
import '../models/item.dart';

class ItemOldPasswordsScreen extends StatefulWidget {
  static const routeName = '/item-old-passwords';

  ItemOldPasswordsScreen({this.item});

  final Item item;

  @override
  _ItemOldPasswordsScreenState createState() => _ItemOldPasswordsScreenState();
}

class _ItemOldPasswordsScreenState extends State<ItemOldPasswordsScreen> {
  CriptoProvider _cripto;

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
        title: Text(
          widget.item.title,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.item.passwords.length,
        itemBuilder: (ctx, i) {
          return Container(
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
                    'password',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      _cripto.decryptPassword(widget.item.passwords[i]),
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
          );
        },
      ),
    );
  }
}
