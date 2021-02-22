import 'package:flutter/material.dart';

import 'package:keyway/models/alpha.dart';

class AlphaLockedCard extends StatelessWidget {
  const AlphaLockedCard({Key key, this.alpha}) : super(key: key);

  final Alpha alpha;

  Color _setAvatarLetterColor() {
    Color _color = Color(alpha.color);
    double bgDelta =
        _color.red * 0.299 + _color.green * 0.587 + _color.blue * 0.114;
    return (255 - bgDelta > 105)
        ? Colors.white.withAlpha(96)
        : Colors.black.withAlpha(96);
  }

  _onTap(BuildContext context) {
    Scaffold.of(context).showSnackBar(
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
          backgroundColor: alpha.color != null
              ? Color(alpha.color).withAlpha(96)
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
        title: Text(
          alpha.title != null ? alpha.title : '',
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
          backgroundColor: Colors.grey,
          label: Text(
            alpha.shortDate != null ? alpha.shortDate : '',
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
