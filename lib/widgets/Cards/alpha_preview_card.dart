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
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            width: 3,
            color: alpha.repeated == 'y'
                ? Colors.red
                : alpha.expired == 'y'
                    ? Colors.orange
                    : Colors.green,
          )),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              alpha.color != null ? Color(alpha.color) : Colors.grey,
          child: Text(
            alpha.title != null ?? alpha.title.isNotEmpty
                ? alpha.title.substring(0, 1).toUpperCase()
                : '',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        title: Text(alpha.title != null ? alpha.title : ''),
        subtitle: Text(alpha.shortDate != null ? alpha.shortDate : ''),
        onTap: null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                child: Icon(Icons.copy_rounded),
                onTap: null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                child: Icon(Icons.remove_red_eye_outlined),
                onTap: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
