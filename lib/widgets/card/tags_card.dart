import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/item.dart';
import '../../models/tag.dart';
import '../../providers/item_provider.dart';
import '../../screens/tag_add_screen.dart';

class TagsCard extends StatefulWidget {
  const TagsCard({Key? key, this.item}) : super(key: key);

  final Item? item;

  @override
  _TagsCardState createState() => _TagsCardState();
}

class _TagsCardState extends State<TagsCard> {
  Future<List<Tag>>? _getTags;
  late List<Tag> _tagList;
  List<Widget>? _chips;
  String? _widgetTags;

  Future<List<Tag>> _tagsList() async => _tagList =
      await Provider.of<ItemProvider>(context, listen: false).getTags();

  List<Widget>? _tags(List<Tag> tags, bool interact) {
    _chips = <Widget>[];
    tags.forEach(
      (tag) {
        tag.selected = _widgetTags!.contains('<${tag.tagName}>');
        _chips!.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              backgroundColor: Colors.grey,
              selected: tag.selected,
              selectedColor: Colors.grey[200],
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
    if (_widgetTags!.contains('<${tag.tagName}>')) {
      _widgetTags = _widgetTags!.replaceAll('<${tag.tagName}>', '');
    } else {
      _widgetTags = _widgetTags! + '<${tag.tagName}>';
    }
    widget.item!.addRemoveTag(tag.tagName);
    setState(() {});
  }

  void _onReturn(Tag? tag) {
    if (tag != null) {
      tagTapped(tag, true);
      _tagList.add(tag);
    }
    setState(() {});
  }

  @override
  void initState() {
    if (widget.item != null) _widgetTags = widget.item!.tags;
    _getTags = _tagsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tags',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            Container(
              height: 64.0,
              width: double.infinity,
              child: FutureBuilder(
                  future: _getTags,
                  builder: (ctx, snap) {
                    switch (snap.connectionState) {
                      case ConnectionState.done:
                        return _tagList.length > 0
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
                                      children: _tags(_tagList, true)!,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.add_circle_outline_rounded,
                                      size: 32,
                                      color: Colors.grey,
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
                            : TextButton.icon(
                                icon: Icon(
                                  Icons.add_circle,
                                  color: Colors.grey,
                                ),
                                label: Text(
                                  'ADD NEW TAG',
                                  style: TextStyle(fontSize: 16),
                                ),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TagAddScreen(),
                                  ),
                                ).then((tag) => _onReturn(tag)),
                              );
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
