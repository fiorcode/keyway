import 'package:flutter/material.dart';

import '../../helpers/date_helper.dart';
import '../../models/item.dart';

class ItemLockedCard extends StatelessWidget {
  const ItemLockedCard({Key key, this.item}) : super(key: key);

  final Item item;

  Color _setAvatarLetterColor() {
    Color _color = Color(item.avatarColor);
    double bgDelta =
        _color.red * 0.299 + _color.green * 0.587 + _color.blue * 0.114;
    return (255 - bgDelta > 105)
        ? Colors.white.withAlpha(96)
        : Colors.black.withAlpha(96);
  }

  _onTap(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Unlock first, please.',
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      clipBehavior: Clip.antiAlias,
      shadowColor: Colors.grey[700],
      elevation: 8,
      shape: StadiumBorder(),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.all(4),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: item.avatarColor != null
              ? Color(item.avatarColor).withAlpha(96)
              : Colors.grey,
          child: Text(
            item.title != null ?? item.title.isNotEmpty
                ? item.title.substring(0, 1).toUpperCase()
                : '',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _setAvatarLetterColor(),
            ),
          ),
        ),
        title: Text(
          item.title != null ? item.title : '',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w300,
            color: Colors.black,
          ),
        ),
        onTap: () => _onTap(context),
        trailing: Chip(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 4,
          visualDensity: VisualDensity.compact,
          label: Text(
            item.date != null ? DateHelper.shortDate(item.date) : '',
            style: TextStyle(
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
