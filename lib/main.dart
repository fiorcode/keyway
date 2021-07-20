import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'providers/cripto_provider.dart';
import 'providers/item_provider.dart';
import 'providers/nist_provider.dart';
import 'screens/addresses_screen.dart';
import 'screens/cpe23uri_cve_screen.dart';
import 'screens/cve_screen.dart';
import 'screens/item_deleted_view_screen.dart';
import 'screens/item_edit_screen.dart';
import 'screens/item_view_screen.dart';
import 'screens/items_with_old_passwords_screen.dart';
import 'screens/item_history_screen.dart';
import 'screens/pins_screen.dart';
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
import 'screens/all_items_screen.dart';
import 'screens/item_password_screen.dart';
import 'screens/passwords_screen.dart';
import 'screens/usernames_screen.dart';
import 'package:keyway/screens/notes_screen.dart';
import 'package:keyway/screens/cpe23uri_screen.dart';
import 'package:keyway/screens/devices_screen.dart';

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
          AllItemsListScreen.routeName: (ctx) => AllItemsListScreen(),
          ItemPasswordListScreen.routeName: (ctx) => ItemPasswordListScreen(),
          PasswordsListScreen.routeName: (ctx) => PasswordsListScreen(),
          UsernamesListScreen.routeName: (ctx) => UsernamesListScreen(),
          PinsListScreen.routeName: (ctx) => PinsListScreen(),
          NotesListScreen.routeName: (ctx) => NotesListScreen(),
          AddressesListScreen.routeName: (ctx) => AddressesListScreen(),
          DevicesListScreen.routeName: (ctx) => DevicesListScreen(),
          Cpe23uriListScreen.routeName: (ctx) => Cpe23uriListScreen(),
          Cpe23uriCveListScreen.routeName: (ctx) => Cpe23uriCveListScreen(),
          CveListScreen.routeName: (ctx) => CveListScreen(),
          ProductSearchScreen.routeName: (ctx) => ProductSearchScreen(),
        },
      ),
    );
  }
}
