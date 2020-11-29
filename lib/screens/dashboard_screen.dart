import 'package:flutter/material.dart';

import '../screens/backup_screen.dart';
import '../screens/data_screen.dart';
import '../widgets/Cards/dashboard_card.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/dash';
  @override
  Widget build(BuildContext context) {
    Color _primary = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: _primary),
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          children: [
            DashboardCard(
              icon: Icon(Icons.cloud_upload, color: _primary, size: 64),
              title: Text(
                'Backup',
                style: TextStyle(color: _primary, fontSize: 20),
              ),
              goTo: () =>
                  Navigator.of(context).pushNamed(BackupScreen.routeName),
            ),
            DashboardCard(
              icon: Icon(Icons.storage, color: _primary, size: 64),
              title: Text(
                'Data',
                style: TextStyle(color: _primary, fontSize: 20),
              ),
              goTo: () => Navigator.of(context).pushNamed(DataScreen.routeName),
            ),
            DashboardCard(
              icon: Icon(Icons.monetization_on, color: _primary, size: 64),
              title: Text(
                'Donate',
                style: TextStyle(color: _primary, fontSize: 20),
              ),
              goTo: () {},
            ),
          ],
        ),
      ),
    );
  }
}
