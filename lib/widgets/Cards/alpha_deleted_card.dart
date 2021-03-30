import 'package:flutter/material.dart';

import 'package:keyway/models/deleted_alpha.dart';
import 'package:keyway/screens/alpha_view_screen.dart';

class AlphaDeletedCard extends StatelessWidget {
  const AlphaDeletedCard({Key key, this.alpha, this.onReturn})
      : super(key: key);

  final DeletedAlpha alpha;
  final Function onReturn;

  _onTap(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AlphaViewScreen(alpha: alpha),
        ),
      ).then((_) => onReturn());

  Color _setAvatarLetterColor() {
    if (alpha.colorLetter >= 0) return Color(alpha.colorLetter);
    Color _c = Color(alpha.color);
    double _bgDelta = _c.red * 0.299 + _c.green * 0.587 + _c.blue * 0.114;
    return (255 - _bgDelta > 105) ? Colors.white : Colors.black;
  }

  Text _setTitle() => Text(
        alpha.title,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w300,
          color: Colors.black,
        ),
      );

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
        onTap: () => _onTap(context),
        trailing: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(Icons.chevron_right),
          ),
        ),
      ),
    );
  }
}
