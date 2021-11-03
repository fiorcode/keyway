import 'package:flutter/material.dart';
import 'package:keyway/helpers/date_helper.dart';
import 'package:keyway/helpers/error_helper.dart';
import 'package:keyway/models/item_password.dart';
import 'package:keyway/models/password.dart';
import 'package:provider/provider.dart';

import '../providers/cripto_provider.dart';
import '../models/item.dart';

class ItemOldPasswordsScreen extends StatefulWidget {
  static const routeName = '/item-old-passwords';

  ItemOldPasswordsScreen({this.item});

  final Item? item;

  @override
  _ItemOldPasswordsScreenState createState() => _ItemOldPasswordsScreenState();
}

class _ItemOldPasswordsScreenState extends State<ItemOldPasswordsScreen> {
  Future<void>? _decryptPasswords;

  Future<void> _decryptPasswordsAsync() async {
    CriptoProvider _c = Provider.of<CriptoProvider>(context, listen: false);
    return _c.decryptItemPasswords(widget.item!);
  }

  @override
  void initState() {
    _decryptPasswords = _decryptPasswordsAsync();
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
          widget.item!.title!,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder(
        future: _decryptPasswords,
        builder: (ctx, snap) {
          switch (snap.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snap.hasError) {
                return ErrorBody(snap.error);
              } else {
                return ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: widget.item!.itemPasswords!.length,
                  itemBuilder: (ctx, i) {
                    ItemPassword _ip = widget.item!.itemPasswords![i];
                    Password _p = widget.item!.passwords!
                        .where((p) => p.passwordId == _ip.fkPasswordId)
                        .first;
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
                              DateHelper.ddMMyyHm(_ip.passwordDate),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                _p.passwordDec!,
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
                );
              }
            default:
              return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
