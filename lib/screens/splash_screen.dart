import 'package:flutter/material.dart';
import 'package:keyway/providers/item_provider.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/cripto_provider.dart';
import 'package:keyway/screens/items_screen.dart';
// import 'package:keyway/screens/set_password_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  CriptoProvider _cripto;
  Future<void> _firstRun;

  Future<void> _checkFirstRun() async {
    _cripto = Provider.of<CriptoProvider>(context, listen: false);
    if (await _cripto.isMasterKey()) {
      Navigator.of(context).pushReplacementNamed(ItemsListScreen.routeName);
    } else {
      if (await _cripto.initialSetup('Qwe123!')) {
        await ItemProvider().mockData();
        Navigator.of(context).pushReplacementNamed(ItemsListScreen.routeName);
      }
      // Navigator.of(context).pushReplacementNamed(SetPasswordScreen.routeName);
    }
  }

  @override
  void initState() {
    _firstRun = _checkFirstRun();
    super.initState();
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
            case ConnectionState.waiting:
              return Center(
                child: Image.asset("assets/icon.png"),
              );
              break;
            default:
              return Center(
                child: Image.asset("assets/error.png"),
              );
          }
        },
      ),
    );
  }
}
