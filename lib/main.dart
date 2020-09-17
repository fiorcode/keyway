import 'package:flutter/material.dart';
import 'package:keyway/providers/drive_provider.dart';
import 'package:provider/provider.dart';

import 'providers/cripto_provider.dart';
import 'providers/item_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/set_password_screen.dart';
import 'screens/items_screen.dart';
import 'screens/alpha_screen.dart';
import 'screens/backup_screen.dart';
import 'screens/keyhole_screen.dart';
import 'screens/dashboard_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: CriptoProvider()),
        ChangeNotifierProvider.value(value: ItemProvider()),
        ChangeNotifierProvider.value(value: DriveProvider()),
      ],
      child: MaterialApp(
        title: 'Keyway',
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
          DashboardScreen.routeName: (ctx) => DashboardScreen(),
          KeyholeScreen.routeName: (ctx) => KeyholeScreen(),
          AlphaScreen.routeName: (ctx) => AlphaScreen(),
          BackupScreen.routeName: (ctx) => BackupScreen(),
        },
      ),
    );
  }
}
