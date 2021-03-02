import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/models/tag.dart';
import 'package:keyway/providers/item_provider.dart';

class TagsListView extends StatefulWidget {
  const TagsListView({Key key, this.tagTap, this.tags = ''}) : super(key: key);

  final Function tagTap;
  final String tags;

  @override
  _TagsListViewState createState() => _TagsListViewState();
}

class _TagsListViewState extends State<TagsListView> {
  ItemProvider _items;
  Future<List<Tag>> _getTags;
  List<Widget> _chips;
  String _widgetTags;

  Future<List<Tag>> _tagsList() async => await _items.getTags();

  List<Widget> _tags(List<Tag> tags) {
    _chips = List<Widget>();
    tags.forEach(
      (tag) {
        bool _selected = _widgetTags.contains('<${tag.tagName}>');
        _chips.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              backgroundColor: Colors.grey,
              selected: _selected,
              selectedColor: Colors.white,
              onSelected: (selected) => tagTapped(tag, selected),
              label: Text(
                tag.tagName,
                style: TextStyle(
                  color: _selected ? Colors.grey : Colors.white,
                  fontWeight: _selected ? FontWeight.bold : null,
                ),
              ),
              elevation: _selected ? 8.0 : 0.0,
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
    widget.tagTap(tag);
    setState(() {});
  }

  @override
  void initState() {
    _items = Provider.of<ItemProvider>(context, listen: false);
    _widgetTags = widget.tags;
    _getTags = _tagsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.0,
      child: FutureBuilder(
          future: _getTags,
          builder: (ctx, snap) {
            switch (snap.connectionState) {
              case ConnectionState.done:
                return ListView(
                  scrollDirection: Axis.horizontal,
                  children: _tags(snap.data),
                );
                break;
              default:
                return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
