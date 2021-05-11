import 'package:flutter/material.dart';

import '../../models/item.dart';
import '../../screens/item_history_screen.dart';

class ItemWithOldPasswordsCard extends StatelessWidget {
  const ItemWithOldPasswordsCard({Key key, this.item, this.onReturn})
      : super(key: key);

  final Item item;
  final Function onReturn;

  _onTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemHistoryScreen(itemId: item.itemId),
      ),
    ).then((_) => onReturn());
  }

  Color _setAvatarLetterColor() {
    if (item.avatarLetterColor >= 0) return Color(item.avatarLetterColor);
    Color _color = Color(item.avatarColor);
    double bgDelta =
        _color.red * 0.299 + _color.green * 0.587 + _color.blue * 0.114;
    return (255 - bgDelta > 105) ? Colors.white : Colors.black;
  }

  Text _setTitle() {
    return Text(
      item.title,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w300,
        color: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 8,
      shape: StadiumBorder(),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.all(4),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor:
              item.avatarColor != null ? Color(item.avatarColor) : Colors.grey,
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
        title: _setTitle(),
        onTap: () => _onTap(context),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}