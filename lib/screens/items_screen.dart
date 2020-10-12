import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/cripto_provider.dart';
import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/screens/alpha_screen.dart';
import 'package:keyway/screens/dashboard_screen.dart';
import 'package:keyway/widgets/alpha_card.dart';
import 'package:keyway/widgets/TextFields/unlock_text_field.dart';

class ItemsListScreen extends StatefulWidget {
  static const routeName = '/items';

  @override
  _ItemsListScreenState createState() => _ItemsListScreenState();
}

class _ItemsListScreenState extends State<ItemsListScreen> {
  CriptoProvider cripto;
  ItemProvider elements;
  bool _unlocking = false;

  _lockSwitch() {
    setState(() {
      _unlocking = !_unlocking;
    });
  }

  @override
  Widget build(BuildContext context) {
    cripto = Provider.of<CriptoProvider>(context);
    elements = Provider.of<ItemProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.settings),
          onPressed: () =>
              Navigator.of(context).pushNamed(DashboardScreen.routeName),
        ),
        title: cripto.locked
            ? IconButton(
                icon: Icon(
                  Icons.lock_outline,
                  color: _unlocking ? Colors.orange : Colors.red,
                ),
                onPressed: cripto.locked ? _lockSwitch : null,
              )
            : IconButton(
                icon: Icon(Icons.lock_open, color: Colors.green),
                onPressed: null),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AlphaScreen.routeName);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: elements.fetchAndSetItems(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : Consumer<ItemProvider>(
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        Icons.blur_on,
                        size: 128,
                        color: Colors.white54,
                      ),
                    ),
                    if (_unlocking && cripto.locked)
                      Container(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                          child: Container(
                            color: Colors.black.withOpacity(0.1),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: UnlockTextField(_lockSwitch),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                builder: (ctx, lib, ch) => lib.items.length <= 0
                    ? ch
                    : ListView.builder(
                        padding: EdgeInsets.all(8),
                        itemCount: lib.items.length,
                        itemBuilder: (ctx, i) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1),
                            child: AlphaCard(lib.items[i]),
                          );
                        },
                      ),
              ),
      ),
    );
  }
}
