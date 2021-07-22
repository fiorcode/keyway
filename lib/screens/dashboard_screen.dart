import 'package:flutter/material.dart';

import '../screens/data_screen.dart';
import '../widgets/card/dashboard_card.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/dashboard';
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
          crossAxisSpacing: 8,
          childAspectRatio: 1.1,
          mainAxisSpacing: 8,
          padding: EdgeInsets.all(16.0),
          children: [
            DashboardCard(
              icon: Icon(Icons.storage, color: _primary, size: 64),
              title: Text(
                'Data',
                style: TextStyle(color: _primary, fontSize: 20),
              ),
              goTo: () => Navigator.of(context).pushNamed(DataScreen.routeName),
            ),
            DashboardCard(
              icon:
                  Icon(Icons.settings_applications, color: _primary, size: 64),
              title: Text(
                'Options',
                style: TextStyle(color: _primary, fontSize: 20),
              ),
              goTo: () {},
            ),
            DashboardCard(
              icon: Icon(Icons.help_outline, color: _primary, size: 64),
              title: Text(
                'Help',
                style: TextStyle(color: _primary, fontSize: 20),
              ),
              goTo: () {},
            ),
            DashboardCard(
              icon: Icon(Icons.monetization_on, color: _primary, size: 64),
              title: Text(
                'Donate',
                style: TextStyle(color: _primary, fontSize: 20),
              ),
              goTo: () {},
            ),
            // DashboardCard(
            //   icon: Icon(
            //     Icons.settings_backup_restore,
            //     color: _primary,
            //     size: 64,
            //   ),
            //   title: Text(
            //     'Backup',
            //     style: TextStyle(color: _primary, fontSize: 20),
            //   ),
            //   goTo: () =>
            //       Navigator.of(context).pushNamed(BackupScreen.routeName),
            // ),
          ],
        ),
      ),
    );
  }
}
