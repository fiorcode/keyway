import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/models/item.dart';
import 'package:keyway/models/tag.dart';
import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/screens/tag_add_screen.dart';

class TagsListView extends StatefulWidget {
  const TagsListView({Key key, this.item}) : super(key: key);

  final Item item;

  @override
  _TagsListViewState createState() => _TagsListViewState();
}

class _TagsListViewState extends State<TagsListView> {
  ItemProvider _items;
  Future<List<Tag>> _getTags;
  List<Widget> _chips;
  String _widgetTags;

  Future<List<Tag>> _tagsList() async => await _items.getTags();

  List<Widget> _tags(List<Tag> tags, bool interact) {
    _chips = <Widget>[];
    tags.forEach(
      (tag) {
        tag.selected = _widgetTags.contains('<${tag.tagName}>');
        _chips.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              backgroundColor: Colors.grey,
              selected: tag.selected,
              selectedColor: Colors.white,
              onSelected: interact
                  ? (selected) => tagTapped(tag, selected)
                  : (selected) => null,
              label: Text(
                tag.tagName,
                style: TextStyle(
                  color: tag.selected ? Colors.grey : Colors.white,
                  fontWeight: tag.selected ? FontWeight.bold : null,
                ),
              ),
              elevation: tag.selected ? 8.0 : 0.0,
            ),
          ),
        );
      },
    );
    return _chips;
  }

  void tagTapped(Tag tag, bool selected) {
    tag.selected = selected;
    if (_widgetTags.contains('<${tag.tagName}>')) {
      _widgetTags = _widgetTags.replaceAll('<${tag.tagName}>', '');
    } else {
      _widgetTags += '<${tag.tagName}>';
    }
    // widget.tagTap(tag);
    widget.item.addRemoveTag(tag.tagName);
    setState(() {});
  }

  void _onReturn(Tag tag) {
    if (tag != null) tagTapped(tag, true);
    _getTags = _tagsList();
    setState(() {});
  }

  @override
  void initState() {
    _items = Provider.of<ItemProvider>(context, listen: false);
    _widgetTags = widget.item.tags;
    _getTags = _tagsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white54,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 3,
        ),
      ),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Tags',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ),
            Container(
              height: 64.0,
              child: FutureBuilder(
                  future: _getTags,
                  builder: (ctx, snap) {
                    switch (snap.connectionState) {
                      case ConnectionState.done:
                        return (snap.data as List<Tag>).length > 0
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: ListView(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      scrollDirection: Axis.horizontal,
                                      children: _tags(snap.data, true),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.add_circle_outline_rounded,
                                      size: 32,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TagAddScreen(),
                                      ),
                                    ).then((tag) => _onReturn(tag)),
                                  ),
                                ],
                              )
                            : TextButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TagAddScreen(),
                                  ),
                                ).then((tag) => _onReturn(tag)),
                                child: Text(
                                  'ADD NEW TAG',
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 16,
                                  ),
                                ),
                              );
                        break;
                      default:
                        return Center(child: CircularProgressIndicator());
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
