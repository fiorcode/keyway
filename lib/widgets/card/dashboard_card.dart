import 'package:flutter/material.dart';

class DashboardCard extends StatefulWidget {
  DashboardCard({this.icon, this.title, this.color = Colors.grey, this.goTo});

  final Icon icon;
  final Text title;
  final MaterialColor color;
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
        elevation: 8,
        shadowColor: widget.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(width: 3, color: widget.color),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.color[100],
                widget.color[300],
                widget.color[600],
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [widget.icon, widget.title],
          ),
        ),
      ),
    );
  }
}
