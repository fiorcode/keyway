import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../helpers/date_helper.dart';
import '../../models/item.dart';

class ItemCleartextCard extends StatefulWidget {
  const ItemCleartextCard({Key key, this.item, this.deleteItem})
      : super(key: key);

  final Item item;
  final Function deleteItem;

  @override
  _ItemCleartextCardState createState() => _ItemCleartextCardState();
}

class _ItemCleartextCardState extends State<ItemCleartextCard> {
  String _title;
  String _subtitle;

  bool _settings = false;

  void _settingsSwitch() => setState(() => _settings = !_settings);

  void _toClipBoard() async {
    Clipboard.setData(ClipboardData(text: _title)).then(
      (_) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(_subtitle + ' copied'),
          duration: Duration(seconds: 1),
        ),
      ),
    );
  }

  void _createItem() {}

  Future<void> _delete() => widget.deleteItem(widget.item);

  @override
  void initState() {
    _title = widget.item.title;
    _subtitle = 'Created: ' + DateHelper.ddMMyyHm(widget.item.date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shadowColor: Colors.orange,
      elevation: 8,
      shape: StadiumBorder(),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.all(4),
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: SizedBox(
            height: 48,
            width: 48,
            child: FloatingActionButton(
              backgroundColor: Colors.grey[100],
              child: Icon(
                Icons.settings,
                color: Colors.grey,
                size: 24,
              ),
              onPressed: () => _settingsSwitch(),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                _title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: true,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
              ),
            ),
            if (_subtitle.isNotEmpty)
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  _subtitle,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
          ],
        ),
        onTap: () => _settingsSwitch(),
        trailing: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_settings)
                SizedBox(
                  height: 48,
                  width: 48,
                  child: FloatingActionButton(
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.add_circle,
                      color: Colors.white,
                      size: 24,
                    ),
                    heroTag: null,
                    onPressed: _createItem,
                  ),
                ),
              if (_settings)
                SizedBox(
                  height: 48,
                  width: 48,
                  child: FloatingActionButton(
                    backgroundColor: Colors.red,
                    child: Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                      size: 24,
                    ),
                    heroTag: null,
                    onPressed: _delete,
                  ),
                ),
              if (!_settings)
                SizedBox(
                  height: 48,
                  width: 48,
                  child: FloatingActionButton(
                    backgroundColor: Colors.grey[100],
                    child: Icon(Icons.copy, color: Colors.grey, size: 24),
                    heroTag: null,
                    onPressed: _toClipBoard,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
