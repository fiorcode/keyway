import 'package:flutter/material.dart';

import 'package:keyway/screens/splash_screen.dart';

import 'screens/set_password_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Locker',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        primaryColor: Colors.grey[800],
        accentColor: Colors.white,
        backgroundColor: Colors.grey[400],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
      routes: {
        SetPasswordScreen.routeName: (ctx) => SetPasswordScreen(),
      },
    );
  }
}
