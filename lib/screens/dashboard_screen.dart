import 'package:flutter/material.dart';
import 'package:keyway/screens/backup_screen.dart';

import 'package:keyway/widgets/dashboard_card.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/dash';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: ListView(
          children: [
            DashboardCard(
              icon: Icon(Icons.cloud_upload, color: Colors.white, size: 32),
              title: Text(
                'Backup',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                ),
              ),
              goTo: () =>
                  Navigator.of(context).pushNamed(BackupScreen.routeName),
            ),
            DashboardCard(
              icon: Icon(Icons.storage, color: Colors.white, size: 32),
              title: Text(
                'Data',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                ),
              ),
              goTo: () =>
                  Navigator.of(context).pushNamed(BackupScreen.routeName),
            ),
          ],
        ),
      ),
    );
  }
}
