import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/cripto_provider.dart';
// import 'package:keyway/providers/item_provider.dart';
import 'items_screen.dart';
import 'set_password_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late CriptoProvider _cripto;
  Future<void>? _firstRun;

  Future<void> _checkFirstRun() async {
    _cripto = Provider.of<CriptoProvider>(context, listen: false);
    bool _isMK = await _cripto.isMasterKey();
    if (_isMK) {
      Navigator.of(context).pushReplacementNamed(ItemsListScreen.routeName);
    } else {
      // if (await CriptoProvider.initialSetup('Qwe123!')) {
      //   await _cripto.unlock('Qwe123!');
      //   await ItemProvider().mockData();
      //   Navigator.of(context).pushReplacementNamed(ItemsListScreen.routeName);
      // }
      Navigator.of(context).pushReplacementNamed(SetPasswordScreen.routeName);
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
            // case ConnectionState.done:
            //   return Center(
            //     child: Image.asset("assets/icon.png"),
            //   );
            // case ConnectionState.waiting:
            //   return Center(
            //     child: Image.asset("assets/icon.png"),
            //   );
            default:
              return Center(
                child: Image.asset("assets/icon.png"),
              );
          }
        },
      ),
    );
  }
}
