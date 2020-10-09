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
  CriptoProvider cripto;
  @override
  void initState() {
    checkFirstRun();
    super.initState();
  }

  checkFirstRun() async {
    try {
      cripto = Provider.of<CriptoProvider>(context, listen: false);
      bool firstRun = await cripto.isMasterKey();
      if (firstRun) {
        Navigator.of(context).pushReplacementNamed(ItemsListScreen.routeName);
      } else {
        Navigator.of(context).pushReplacementNamed(SetPasswordScreen.routeName);
      }
    } catch (error) {
      throw error;
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
