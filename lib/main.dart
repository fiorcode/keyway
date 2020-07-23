import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/cripto_provider.dart';
import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/screens/splash_screen.dart';
import 'package:keyway/screens/set_password_screen.dart';
import 'package:keyway/screens/items_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: CriptoProvider()),
        ChangeNotifierProvider.value(value: ItemProvider()),
      ],
      child: MaterialApp(
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
          ItemsListScreen.routeName: (ctx) => ItemsListScreen(),
        },
      ),
    );
  }
}
