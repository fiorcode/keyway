import 'package:flutter/material.dart';

import 'package:keyway/models/item.dart';
import 'package:keyway/models/deleted_alpha.dart';
import 'package:keyway/screens/item_history_screen.dart';

class AlphaHistoryListCard extends StatelessWidget {
  const AlphaHistoryListCard({Key key, this.alpha, this.onReturn})
      : super(key: key);

  final Item alpha;
  final Function onReturn;

  _onTap(BuildContext context) {
    int _id;
    if (alpha is DeletedAlpha)
      _id = (alpha as DeletedAlpha).itemIdFK;
    else
      _id = alpha.itemId;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemHistoryScreen(itemId: _id),
      ),
    ).then((_) => onReturn());
  }

  Color _setAvatarLetterColor() {
    if (alpha.avatarLetterColor >= 0) return Color(alpha.avatarLetterColor);
    Color _color = Color(alpha.avatarColor);
    double bgDelta =
        _color.red * 0.299 + _color.green * 0.587 + _color.blue * 0.114;
    return (255 - bgDelta > 105) ? Colors.white : Colors.black;
  }

  Text _setTitle() {
    return Text(
      alpha.title,
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
          backgroundColor: alpha.avatarColor != null
              ? Color(alpha.avatarColor)
              : Colors.grey,
          child: Text(
            alpha.title != null ?? alpha.title.isNotEmpty
                ? alpha.title.substring(0, 1).toUpperCase()
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
