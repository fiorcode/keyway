import 'package:flutter/material.dart';

class DashboardCard extends StatefulWidget {
  DashboardCard({this.icon, this.title, this.goTo});

  final Icon icon;
  final Text title;
  final Function goTo;

  @override
  _DashboardCardState createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.goTo,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shadowColor: Colors.green,
        elevation: 8,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(width: 1, color: Colors.green)),
        margin: EdgeInsets.only(left: 32, right: 32, top: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              color: Theme.of(context).primaryColor,
              child: widget.icon,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget.title,
            )
          ],
        ),
      ),
    );
  }
}
