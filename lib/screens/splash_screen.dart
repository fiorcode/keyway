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

  _checkFirstRun() async {
    if (await _cripto.isMasterKey()) {
      await _item.fetchItems();
      if (_item.items.length <= 0) {
        Future<void> _mock = _item.mockData(_cripto);
        _mock.then((value) => Navigator.of(context)
            .pushReplacementNamed(ItemsListScreen.routeName));
      } else
        Navigator.of(context).pushReplacementNamed(ItemsListScreen.routeName);
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
    _checkFirstRun();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Image.asset("assets/icon.png"),
      ),
    );
  }
}
