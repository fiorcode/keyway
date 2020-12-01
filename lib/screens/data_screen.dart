import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:keyway/helpers/db_helper.dart';
import 'package:keyway/helpers/warning_helper.dart';
import 'package:keyway/screens/items_history_screen.dart';

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

  FutureBuilder _setDBSize() {
    return FutureBuilder(
      future: _dbSize,
      builder: (ctx, snap) {
        switch (snap.connectionState) {
          case ConnectionState.waiting:
            return Text('Size: Calculating...');
            break;
          case ConnectionState.done:
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
                Text(
                  '${snap.data} Bytes',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            );
            break;
          default:
            return Text('Size: Unknown');
        }
      },
    );
  }

  FutureBuilder _setDBLastModified() {
    return FutureBuilder(
      future: _dbLastModified,
      builder: (ctx, snap) {
        switch (snap.connectionState) {
          case ConnectionState.waiting:
            return Text('Last Modified: Calculating...');
            break;
          case ConnectionState.done:
            DateFormat dateFormat = DateFormat('dd/MM/yyyy H:mm');
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
                Text(
                  '${dateFormat.format(snap.data)}',
                  style: TextStyle(fontSize: 14),
                ),
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
    if (await WarningHelper.deleteDBWarning(context)) {}
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
                            Icons.donut_small,
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ButtonTheme(
                  height: 48,
                  minWidth: 128,
                  shape: StadiumBorder(
                    side: BorderSide(width: 3, color: Colors.white),
                  ),
                  child: RaisedButton.icon(
                    color: Theme.of(context).backgroundColor,
                    onPressed: () => Navigator.of(context)
                        .pushNamed(ItemsHistoryScreen.routeName),
                    icon: Icon(
                      Icons.history,
                      color: Theme.of(context).primaryColor,
                      size: 32,
                    ),
                    label: Row(
                      children: [
                        Text(
                          'Items History',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 24),
                        Icon(Icons.keyboard_arrow_right, size: 32)
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ButtonTheme(
                  height: 48,
                  minWidth: 128,
                  shape: StadiumBorder(
                    side: BorderSide(width: 3, color: Colors.white),
                  ),
                  child: RaisedButton.icon(
                    color: Theme.of(context).backgroundColor,
                    onPressed: () {},
                    icon: Icon(
                      Icons.remove_circle,
                      color: Theme.of(context).primaryColor,
                      size: 32,
                    ),
                    label: Row(
                      children: [
                        Text(
                          'Removed Items',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 24),
                        Icon(Icons.keyboard_arrow_right, size: 32)
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ButtonTheme(
                  height: 48,
                  minWidth: 128,
                  shape: StadiumBorder(
                    side: BorderSide(width: 3, color: Colors.red[200]),
                  ),
                  child: RaisedButton.icon(
                    color: Colors.red,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
