import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'providers/drive_provider.dart';
import 'providers/cripto_provider.dart';
import 'providers/item_provider.dart';
import 'screens/alpha_edit_screen.dart';
import 'screens/alpha_view_screen.dart';
import 'screens/old_passwords_pins_screen.dart';
import 'screens/item_history_screen.dart';
import 'screens/restore_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/set_password_screen.dart';
import 'screens/items_screen.dart';
import 'screens/alpha_add_screen.dart';
import 'screens/backup_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/data_screen.dart';
import 'screens/deleted_items_screen.dart';
import 'screens/tag_add_screen.dart';
import 'screens/tags_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
          primaryColorLight: Colors.grey[100],
          accentColor: Colors.white,
          backgroundColor: Colors.grey[200],
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
        routes: {
          SplashScreen.routeName: (ctx) => SplashScreen(),
          SetPasswordScreen.routeName: (ctx) => SetPasswordScreen(),
          RestoreScreen.routeName: (ctx) => RestoreScreen(),
          ItemsListScreen.routeName: (ctx) => ItemsListScreen(),
          DashboardScreen.routeName: (ctx) => DashboardScreen(),
          AlphaAddScreen.routeName: (ctx) => AlphaAddScreen(),
          AlphaEditScreen.routeName: (ctx) => AlphaEditScreen(),
          AlphaViewScreen.routeName: (ctx) => AlphaViewScreen(),
          BackupScreen.routeName: (ctx) => BackupScreen(),
          DataScreen.routeName: (ctx) => DataScreen(),
          OldPasswordsPinsScreen.routeName: (ctx) => OldPasswordsPinsScreen(),
          ItemHistoryScreen.routeName: (ctx) => ItemHistoryScreen(),
          DeletedItemsScreen.routeName: (ctx) => DeletedItemsScreen(),
          TagsScreen.routeName: (ctx) => TagsScreen(),
          TagAddScreen.routeName: (ctx) => TagAddScreen(),
        },
      ),
    );
  }
}
