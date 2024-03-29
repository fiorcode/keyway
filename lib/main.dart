import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'providers/cripto_provider.dart';
import 'providers/item_provider.dart';
import 'providers/nist_provider.dart';
import 'screens/addresses_screen.dart';
import 'screens/data_views/product_cve_table.dart';
import 'screens/item_edit_screen.dart';
import 'screens/item_view_screen.dart';
import 'screens/notes_screen.dart';
import 'screens/passwords_screen.dart';
import 'screens/pins_screen.dart';
import 'screens/product_search_screen.dart';
import 'screens/products_screen.dart';
import 'screens/products_without_cpe_screen.dart';
import 'screens/restore_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/set_password_screen.dart';
import 'screens/tags_screen.dart';
import 'screens/usernames_screen.dart';
import 'screens/items_screen.dart';
import 'screens/item_add_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/data_screen.dart';
import 'screens/tag_add_screen.dart';
import 'screens/tables_screen.dart';
import 'screens/backup_restore_screen.dart';
import 'screens/danger_zone_screen.dart';
import 'screens/vulnerabilities_screen.dart';

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
import 'screens/data_views/tag_table.dart';
import 'screens/data_views/user_table.dart';
import 'services/notification_service.dart';

final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('keyway\assets\icon.png');

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().init();
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

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
        debugShowCheckedModeBanner: false,
        builder: (BuildContext context, Widget? widget) {
          ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
            return Text(errorDetails.exception.toString());
          };
          return widget!;
        },
        title: 'Keyway',
        theme: ThemeData(
          primarySwatch: Colors.grey,
          primaryColor: Colors.grey[800],
          primaryColorLight: Colors.grey[100],
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
          TagAddScreen.routeName: (ctx) => TagAddScreen(),
          ProductSearchScreen.routeName: (ctx) => ProductSearchScreen(),
          ProductsWithoutCpeScreen.routeName: (ctx) =>
              ProductsWithoutCpeScreen(),
          //Dashboard
          DataScreen.routeName: (ctx) => DataScreen(),
          BackupRestoreScreen.routeName: (ctx) => BackupRestoreScreen(),
          VulnerabilitiesScreen.routeName: (ctx) => VulnerabilitiesScreen(),
          //Data
          PasswordsScreen.routeName: (ctx) => PasswordsScreen(),
          UsernamesScreen.routeName: (ctx) => UsernamesScreen(),
          PinsScreen.routeName: (ctx) => PinsScreen(),
          NotesScreen.routeName: (ctx) => NotesScreen(),
          AddressesScreen.routeName: (ctx) => AddressesScreen(),
          ProductsScreen.routeName: (ctx) => ProductsScreen(),
          TagsScreen.routeName: (ctx) => TagsScreen(),
          TablesScreen.routeName: (ctx) => TablesScreen(),
          DangerZoneScreen.routeName: (ctx) => DangerZoneScreen(),
          //Tables
          ItemTableScreen.routeName: (ctx) => ItemTableScreen(),
          ItemPasswordTableScreen.routeName: (ctx) => ItemPasswordTableScreen(),
          PasswordTableScreen.routeName: (ctx) => PasswordTableScreen(),
          UsernameTableScreen.routeName: (ctx) => UsernameTableScreen(),
          PinTableScreen.routeName: (ctx) => PinTableScreen(),
          NoteTableScreen.routeName: (ctx) => NoteTableScreen(),
          AddressTableScreen.routeName: (ctx) => AddressTableScreen(),
          ProductTableScreen.routeName: (ctx) => ProductTableScreen(),
          ProductCveTableScreen.routeName: (ctx) => ProductCveTableScreen(),
          Cpe23uriTableScreen.routeName: (ctx) => Cpe23uriTableScreen(),
          Cpe23uriCveTableScreen.routeName: (ctx) => Cpe23uriCveTableScreen(),
          CveTableScreen.routeName: (ctx) => CveTableScreen(),
          TagTableScreen.routeName: (ctx) => TagTableScreen(),
          UserTableScreen.routeName: (ctx) => UserTableScreen(),
        },
      ),
    );
  }
}
