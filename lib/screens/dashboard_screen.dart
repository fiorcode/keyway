import 'package:flutter/material.dart';

import '../screens/backup_screen.dart';
import '../screens/data_screen.dart';
import '../widgets/Cards/dashboard_card.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/dash';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          children: [
            DashboardCard(
              icon: Icon(Icons.cloud_upload, color: Colors.white, size: 48),
              title: Text(
                'Backup',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              goTo: () =>
                  Navigator.of(context).pushNamed(BackupScreen.routeName),
            ),
            DashboardCard(
              icon: Icon(Icons.storage, color: Colors.white, size: 48),
              title: Text(
                'Data',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              goTo: () => Navigator.of(context).pushNamed(DataScreen.routeName),
            ),
            DashboardCard(
              icon: Icon(Icons.monetization_on, color: Colors.white, size: 48),
              title: Text(
                'Donate',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              goTo: () {},
            ),
          ],
        ),
      ),
    );
  }
}
