import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'providers/cripto_provider.dart';
import 'providers/item_provider.dart';
import 'providers/nist_provider.dart';
import 'screens/item_deleted_view_screen.dart';
import 'screens/item_edit_screen.dart';
import 'screens/item_view_screen.dart';
import 'screens/items_with_old_passwords_screen.dart';
import 'screens/item_history_screen.dart';
import 'screens/product_search_screen.dart';
import 'screens/restore_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/set_password_screen.dart';
import 'screens/items_screen.dart';
import 'screens/item_add_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/data_screen.dart';
import 'screens/items_deleted_screen.dart';
import 'screens/tag_add_screen.dart';
import 'screens/tags_screen.dart';

import 'screens/data_views/address_table.dart';
import 'screens/data_views/item_table.dart';
import 'screens/data_views/item_password_table.dart';
import 'screens/data_views/note_table.dart';
import 'screens/data_views/password_table.dart';
import 'screens/data_views/pin_table.dart';
import 'screens/data_views/username_table.dart';
import 'screens/data_views/product_table.dart';
import 'screens/data_views/cpe23uri_table.dart';
import 'screens/data_views/cpe23uri_cve_table.dart';
import 'screens/data_views/cve_table.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: CriptoProvider()),
        ChangeNotifierProvider.value(value: ItemProvider()),
        ChangeNotifierProvider.value(value: NistProvider()),
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
          ItemAddScreen.routeName: (ctx) => ItemAddScreen(),
          ItemEditScreen.routeName: (ctx) => ItemEditScreen(),
          ItemViewScreen.routeName: (ctx) => ItemViewScreen(),
          ItemDeletedViewScreen.routeName: (ctx) => ItemDeletedViewScreen(),
          DataScreen.routeName: (ctx) => DataScreen(),
          ItemsWithOldPasswordsScreen.routeName: (ctx) =>
              ItemsWithOldPasswordsScreen(),
          ItemHistoryScreen.routeName: (ctx) => ItemHistoryScreen(),
          ItemsDeletedScreen.routeName: (ctx) => ItemsDeletedScreen(),
          TagsScreen.routeName: (ctx) => TagsScreen(),
          TagAddScreen.routeName: (ctx) => TagAddScreen(),
          ProductSearchScreen.routeName: (ctx) => ProductSearchScreen(),
          ItemTableScreen.routeName: (ctx) => ItemTableScreen(),
          ItemPasswordTableScreen.routeName: (ctx) => ItemPasswordTableScreen(),
          PasswordTableScreen.routeName: (ctx) => PasswordTableScreen(),
          UsernameTableScreen.routeName: (ctx) => UsernameTableScreen(),
          PinTableScreen.routeName: (ctx) => PinTableScreen(),
          NoteTableScreen.routeName: (ctx) => NoteTableScreen(),
          AddressTableScreen.routeName: (ctx) => AddressTableScreen(),
          ProductTableScreen.routeName: (ctx) => ProductTableScreen(),
          Cpe23uriTableScreen.routeName: (ctx) => Cpe23uriTableScreen(),
          Cpe23uriCveTableScreen.routeName: (ctx) => Cpe23uriCveTableScreen(),
          CveTableScreen.routeName: (ctx) => CveTableScreen(),
        },
      ),
    );
  }
}
