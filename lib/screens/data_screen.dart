import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keyway/screens/notes_screen.dart';

import '../helpers/db_helper.dart';
import 'addresses_screen.dart';
import 'products_screen.dart';
import 'tables_screen.dart';
import 'items_deleted_screen.dart';
import 'danger_zone_screen.dart';
import 'pins_screen.dart';
import '../widgets/card/dashboard_card.dart';

class DataScreen extends StatefulWidget {
  static const routeName = '/data';

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  Future<int> _dbSize;
  Future<DateTime> _dbLastModified;

  Future<int> _getDBSize() async => await DBHelper.dbSize();

  Future<DateTime> _getLastModified() async => await DBHelper.dbLastModified();

  FutureBuilder<int> _setDBSize() {
    return FutureBuilder(
      future: _dbSize,
      builder: (ctx, snap) {
        switch (snap.connectionState) {
          case ConnectionState.waiting:
            return Text('Size: Calculating...');
            break;
          case ConnectionState.done:
            String _size = snap.data == null ? '-' : '${snap.data} Bytes';
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Size: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
                Text(_size, style: TextStyle(fontSize: 14)),
              ],
            );
            break;
          default:
            return Text('Size: Unknown');
        }
      },
    );
  }

  FutureBuilder<DateTime> _setDBLastModified() {
    return FutureBuilder(
      future: _dbLastModified,
      builder: (ctx, snap) {
        switch (snap.connectionState) {
          case ConnectionState.waiting:
            return Text('Last Modified: Calculating...');
            break;
          case ConnectionState.done:
            DateFormat dateFormat = DateFormat('dd/MM/yyyy H:mm');
            String _date =
                snap.data == null ? '-' : dateFormat.format(snap.data);
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Last Modified: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
                Text(_date, style: TextStyle(fontSize: 14)),
              ],
            );
            break;
          default:
            return Text('Last Modified: Unknown');
        }
      },
    );
  }

  // Future<void> _deleteDB(BuildContext context) async {
  //   if (await WarningHelper.deleteDB(context)) {
  //     if (await DBHelper.removeDB()) {
  //       Navigator.of(context)
  //           .pushNamedAndRemoveUntil(SplashScreen.routeName, (route) => false);
  //     }
  //   }
  // }

  void _goTo(String route) => Navigator.of(context).pushNamed(route);

  @override
  void initState() {
    _dbSize = _getDBSize();
    _dbLastModified = _getLastModified();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color _primary = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              Card(
                clipBehavior: Clip.antiAlias,
                elevation: 8,
                shadowColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  side: BorderSide(width: 3, color: Colors.white),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.grey[100],
                        Colors.grey[300],
                        Colors.grey[600],
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Database status',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.data_usage,
                            size: 92,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Column(
                          children: [
                            Chip(label: _setDBSize()),
                            Chip(label: _setDBLastModified()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                childAspectRatio: 1.1,
                mainAxisSpacing: 8,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                padding: EdgeInsets.all(16.0),
                children: [
                  DashboardCard(
                    icon: Icon(Icons.pin, color: _primary, size: 48),
                    title: Text(
                      'Pins',
                      style: TextStyle(color: _primary, fontSize: 16),
                    ),
                    onTap: () => _goTo(PinsScreen.routeName),
                  ),
                  DashboardCard(
                    icon: Icon(Icons.note, color: _primary, size: 48),
                    title: Text(
                      'Notes',
                      style: TextStyle(color: _primary, fontSize: 16),
                    ),
                    onTap: () => _goTo(NotesScreen.routeName),
                  ),
                  DashboardCard(
                    icon: Icon(Icons.http, color: _primary, size: 48),
                    title: Text(
                      'Addresses',
                      style: TextStyle(color: _primary, fontSize: 16),
                    ),
                    onTap: () => _goTo(AddressesScreen.routeName),
                  ),
                  DashboardCard(
                    icon: Icon(Icons.router, color: _primary, size: 48),
                    title: Text(
                      'Products',
                      style: TextStyle(color: _primary, fontSize: 16),
                    ),
                    onTap: () => _goTo(ProductsScreen.routeName),
                  ),
                  DashboardCard(
                    icon: Icon(Icons.table_view, color: _primary, size: 48),
                    title: Text(
                      'Tables',
                      style: TextStyle(color: _primary, fontSize: 16),
                    ),
                    onTap: () => _goTo(TablesScreen.routeName),
                  ),
                  DashboardCard(
                    icon: Icon(Icons.delete, color: _primary, size: 48),
                    title: Text(
                      'Deleted items',
                      style: TextStyle(color: _primary, fontSize: 16),
                    ),
                    onTap: () => _goTo(ItemsDeletedScreen.routeName),
                  ),
                  DashboardCard(
                    icon: Icon(Icons.dangerous, color: Colors.white, size: 48),
                    title: Text(
                      'Danger zone',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    color: Colors.red,
                    onTap: () => _goTo(DangerZoneScreen.routeName),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
