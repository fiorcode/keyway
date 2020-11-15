import 'package:flutter/material.dart';

import 'package:keyway/models/item.dart';

class AlphaPreviewCard extends StatelessWidget {
  AlphaPreviewCard(this.alpha);

  final Alpha alpha;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shadowColor: alpha.repeated == 'y'
          ? Colors.red
          : alpha.expired == 'y'
              ? Colors.orange
              : Colors.green,
      elevation: 8,
      shape: StadiumBorder(),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.all(4),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: alpha.color == null || alpha.color == 0
              ? Colors.grey
              : Color(alpha.color),
          child: Text(
            alpha.title != null ?? alpha.title.isNotEmpty
                ? alpha.title.substring(0, 1).toUpperCase()
                : 'T',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          alpha.title != null ? alpha.title : 'Title',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w300,
            color: Colors.black,
          ),
        ),
        onTap: null,
        trailing: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 32,
                width: 32,
                child: FloatingActionButton(
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.copy,
                    color: Colors.white,
                    size: 16,
                  ),
                  heroTag: null,
                  onPressed: null,
                ),
              ),
              SizedBox(width: 8),
              SizedBox(
                height: 32,
                width: 32,
                child: FloatingActionButton(
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.remove_red_eye_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                  heroTag: null,
                  onPressed: null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
