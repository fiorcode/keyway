import 'package:flutter/material.dart';

import 'data_views/address_table.dart';
import 'data_views/cve_table.dart';
import 'data_views/item_table.dart';
import 'data_views/item_password_table.dart';
import 'data_views/note_table.dart';
import 'data_views/password_table.dart';
import 'data_views/pin_table.dart';
import 'data_views/product_cve_table.dart';
import 'data_views/tag_table.dart';
import 'data_views/user_table.dart';
import 'data_views/username_table.dart';
import 'data_views/product_table.dart';
import 'data_views/cpe23uri_table.dart';
import 'data_views/cpe23uri_cve_table.dart';
import '../widgets/card/dashboard_card.dart';

class TablesScreen extends StatefulWidget {
  static const routeName = '/tables';

  @override
  _TablesScreenState createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  void _goTo(String route) => Navigator.of(context).pushNamed(route);

  @override
  Widget build(BuildContext context) {
    Color _primary = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text('Tables', style: TextStyle(color: Colors.grey)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          childAspectRatio: 1.1,
          mainAxisSpacing: 8,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          padding: EdgeInsets.all(16.0),
          children: [
            DashboardCard(
              icon: Icon(Icons.view_list, color: _primary, size: 48),
              title: Text(
                'Item',
                style: TextStyle(color: _primary, fontSize: 16),
              ),
              onTap: () => _goTo(ItemTableScreen.routeName),
            ),
            DashboardCard(
              icon: Icon(Icons.pivot_table_chart, color: _primary, size: 48),
              title: Text(
                'ItemPasswords',
                style: TextStyle(color: _primary, fontSize: 16),
              ),
              onTap: () => _goTo(ItemPasswordTableScreen.routeName),
            ),
            DashboardCard(
              icon: Icon(Icons.password, color: _primary, size: 48),
              title: Text(
                'Passwords',
                style: TextStyle(color: _primary, fontSize: 16),
              ),
              onTap: () => _goTo(PasswordTableScreen.routeName),
            ),
            DashboardCard(
              icon: Icon(Icons.account_box, color: _primary, size: 48),
              title: Text(
                'Usernames',
                style: TextStyle(color: _primary, fontSize: 16),
              ),
              onTap: () => _goTo(UsernameTableScreen.routeName),
            ),
            DashboardCard(
              icon: Icon(Icons.pin, color: _primary, size: 48),
              title: Text(
                'PINs',
                style: TextStyle(color: _primary, fontSize: 16),
              ),
              onTap: () => _goTo(PinTableScreen.routeName),
            ),
            DashboardCard(
              icon: Icon(Icons.note_alt, color: _primary, size: 48),
              title: Text(
                'Notes',
                style: TextStyle(color: _primary, fontSize: 16),
              ),
              onTap: () => _goTo(NoteTableScreen.routeName),
            ),
            DashboardCard(
              icon: Icon(Icons.http, color: _primary, size: 48),
              title: Text(
                'Addresses',
                style: TextStyle(color: _primary, fontSize: 16),
              ),
              onTap: () => _goTo(AddressTableScreen.routeName),
            ),
            DashboardCard(
              icon: Icon(Icons.router, color: _primary, size: 48),
              title: Text(
                'Products',
                style: TextStyle(color: _primary, fontSize: 16),
              ),
              onTap: () => _goTo(ProductTableScreen.routeName),
            ),
            DashboardCard(
              icon: Icon(Icons.receipt, color: _primary, size: 48),
              title: Text(
                'CPEs',
                style: TextStyle(color: _primary, fontSize: 16),
              ),
              onTap: () => _goTo(Cpe23uriTableScreen.routeName),
            ),
            DashboardCard(
              icon: Icon(Icons.pivot_table_chart, color: _primary, size: 48),
              title: Text(
                'CpeCves',
                style: TextStyle(color: _primary, fontSize: 16),
              ),
              onTap: () => _goTo(Cpe23uriCveTableScreen.routeName),
            ),
            DashboardCard(
              icon: Icon(Icons.coronavirus, color: _primary, size: 48),
              title: Text(
                'CVEs',
                style: TextStyle(color: _primary, fontSize: 16),
              ),
              onTap: () => _goTo(CveTableScreen.routeName),
            ),
            DashboardCard(
              icon: Icon(Icons.bug_report, color: _primary, size: 48),
              title: Text(
                'ProductCVEs',
                style: TextStyle(color: _primary, fontSize: 16),
              ),
              onTap: () => _goTo(ProductCveTableScreen.routeName),
            ),
            DashboardCard(
              icon: Icon(Icons.tag, color: _primary, size: 48),
              title: Text(
                'Tags',
                style: TextStyle(color: _primary, fontSize: 16),
              ),
              onTap: () => _goTo(TagTableScreen.routeName),
            ),
            DashboardCard(
              icon: Icon(Icons.manage_accounts, color: _primary, size: 48),
              title: Text(
                'User',
                style: TextStyle(color: _primary, fontSize: 16),
              ),
              onTap: () => _goTo(UserTableScreen.routeName),
            ),
          ],
        ),
      ),
    );
  }
}
