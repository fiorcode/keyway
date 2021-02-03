import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/cripto_provider.dart';
import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/screens/items_screen.dart';
import 'package:keyway/screens/set_password_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  CriptoProvider _cripto;
  ItemProvider _item;
  Future<void> _firstRun;

  Future<void> _checkFirstRun() async {
    if (await _cripto.isMasterKey()) {
      _item.fetchItems('').then((value) {
        if (_item.items.length <= 0) {
          _item.mockData(_cripto).then((value) => Navigator.of(context)
              .pushReplacementNamed(ItemsListScreen.routeName));
        } else {
          Navigator.of(context).pushReplacementNamed(ItemsListScreen.routeName);
        }
      });
    } else {
      Navigator.of(context).pushReplacementNamed(SetPasswordScreen.routeName);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _cripto = Provider.of<CriptoProvider>(context, listen: false);
    _item = Provider.of<ItemProvider>(context, listen: false);
    _firstRun = _checkFirstRun();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: FutureBuilder(
        future: _firstRun,
        builder: (ctx, snap) {
          switch (snap.connectionState) {
            case ConnectionState.done:
              return Center(
                child: Image.asset("assets/icon.png"),
              );
              break;
            default:
              return Center(
                child: Column(
                  children: [
                    Image.asset("assets/icon.png"),
                    CircularProgressIndicator(),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}
