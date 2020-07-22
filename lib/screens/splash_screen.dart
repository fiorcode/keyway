import 'package:flutter/material.dart';
import 'package:keyway/screens/set_password_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static SharedPreferences _pref;

  @override
  void initState() {
    super.initState();
    checkFirstRun();
  }

  Future checkFirstRun() async {
    try {
      _pref = await SharedPreferences.getInstance();
      var _mk = _pref.getString('masterKey');
      if (_mk == null)
        Navigator.of(context).pushReplacementNamed(SetPasswordScreen.routeName);
    } catch (error) {}
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
