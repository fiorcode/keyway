import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/cripto_provider.dart';
import 'package:keyway/screens/items_screen.dart';
import 'package:keyway/screens/set_password_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkFirstRun();
    super.initState();
  }

  checkFirstRun() async {
    CriptoProvider cripto = Provider.of<CriptoProvider>(context, listen: false);
    if (await cripto.isMasterKey()) {
      Navigator.of(context).pushReplacementNamed(ItemsListScreen.routeName);
    } else {
      Navigator.of(context).pushReplacementNamed(SetPasswordScreen.routeName);
    }
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
