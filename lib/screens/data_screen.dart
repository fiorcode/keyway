import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helpers/db_helper.dart';
import '../helpers/warning_helper.dart';
import '../screens/deleted_items_screen.dart';
import '../screens/old_passwords_pins_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/tags_screen.dart';

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

  Future<void> _deleteDB(BuildContext context) async {
    if (await WarningHelper.deleteDB(context)) {
      if (await DBHelper.removeDB()) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(SplashScreen.routeName, (route) => false);
      }
    }
  }

  @override
  void initState() {
    _dbSize = _getDBSize();
    _dbLastModified = _getLastModified();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                          'Local Database Status',
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
              SizedBox(height: 16),
              Container(
                width: 256,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    primary: Colors.white,
                  ),
                  onPressed: () =>
                      Navigator.of(context).pushNamed(TagsScreen.routeName),
                  icon: Icon(
                    Icons.tag,
                    color: Theme.of(context).primaryColor,
                    size: 32,
                  ),
                  label: Text(
                    'Tags',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: 256,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    primary: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context)
                      .pushNamed(OldPasswordsPinsScreen.routeName),
                  icon: Icon(
                    Icons.history,
                    color: Theme.of(context).primaryColor,
                    size: 32,
                  ),
                  label: Text(
                    'Old Passwords',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: 256,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    primary: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context)
                      .pushNamed(DeletedItemsScreen.routeName),
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).primaryColor,
                    size: 32,
                  ),
                  label: Text(
                    'Deleted Items',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 48),
              Container(
                width: 256,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    primary: Colors.red,
                  ),
                  onPressed: () => _deleteDB(context),
                  icon: Icon(
                    Icons.delete_forever,
                    color: Colors.white,
                    size: 32,
                  ),
                  label: Text(
                    'Delete Database',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
