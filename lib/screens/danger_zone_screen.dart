import 'package:flutter/material.dart';

import '../widgets/card/dashboard_card.dart';

class DangerZoneScreen extends StatefulWidget {
  static const routeName = '/danger-zone';

  @override
  _DangerZoneScreenState createState() => _DangerZoneScreenState();
}

class _DangerZoneScreenState extends State<DangerZoneScreen> {
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
                color: Colors.red[100],
                shadowColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  side: BorderSide(width: 3, color: Colors.red),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('assets/error.png', height: 92),
                      ),
                      Text(
                        'This actions are final',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Unless you have an up to date backup of your database, you won\'t be able to undo them',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      ),
                    ],
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
                    icon: Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                      size: 48,
                    ),
                    title: Text(
                      'Delete database',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    color: Colors.red,
                    // goTo: () => _goTo(ItemTableScreen.routeName),
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
