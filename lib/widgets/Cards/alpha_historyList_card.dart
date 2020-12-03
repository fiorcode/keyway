import 'package:flutter/material.dart';

import 'package:keyway/models/item.dart';
import 'package:keyway/screens/item_history_screen.dart';

class AlphaHistoryListCard extends StatelessWidget {
  const AlphaHistoryListCard({Key key, this.alpha, this.onReturn})
      : super(key: key);

  final Alpha alpha;
  final Function onReturn;

  _onTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemHistoryScreen(itemId: alpha.id),
      ),
    ).then((_) => onReturn());
  }

  Color _setAvatarLetterColor() {
    Color _color = Color(alpha.color);
    double bgDelta =
        _color.red * 0.299 + _color.green * 0.587 + _color.blue * 0.114;
    return (255 - bgDelta > 105) ? Colors.white : Colors.black;
  }

  Text _setTitle() {
    return Text(
      alpha.title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w300,
        color: Colors.black,
      ),
    );
  }

  Color _setWarningColor() => alpha.repeated == 'y'
      ? Colors.red
      : alpha.expired == 'y'
          ? Colors.orange
          : Colors.green;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shadowColor: _setWarningColor(),
      elevation: 8,
      shape: StadiumBorder(),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.all(4),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor:
              alpha.color != null ? Color(alpha.color) : Colors.grey,
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
        onTap: _onTap(context),
        trailing: Icon(Icons.chevron_left),
      ),
    );
  }
}
