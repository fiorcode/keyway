import 'package:flutter/material.dart';

class DashboardCard extends StatefulWidget {
  DashboardCard(this._icon, this._title);

  final Icon _icon;
  final Text _title;

  @override
  _DashboardCardState createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shadowColor: Colors.green,
      elevation: 8,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(width: 1, color: Colors.green)),
      margin: EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Theme.of(context).primaryColor,
            child: widget._icon,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget._title,
          )
        ],
      ),
    );
  }
}
