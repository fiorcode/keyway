import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/models/tag.dart';

class TagsFilterList extends StatefulWidget {
  const TagsFilterList(this.tag, this.tagsSwitch);

  final Tag? tag;
  final Function tagsSwitch;

  @override
  _TagsFilterListState createState() => _TagsFilterListState();
}

class _TagsFilterListState extends State<TagsFilterList> {
  Future<List<Tag>>? _getTags;
  List<Widget>? _buttons;

  List<Widget>? _tags(List<Tag> tags) {
    _buttons = <Widget>[];
    tags.forEach(
      (tag) {
        if (widget.tag != null)
          tag.selected = tag.tagName == widget.tag!.tagName;
        else
          tag.selected = false;
        _buttons!.add(
          TextButton.icon(
            icon: Icon(
              Icons.tag,
              color: Color(tag.tagColor),
              size: tag.selected ? 20 : 14,
            ),
            onPressed: () {
              setState(() {
                tag.selected = !tag.selected;
              });
              widget.tagsSwitch(tag);
            },
            label: Text(
              tag.tagName,
              style: TextStyle(
                color: Color(tag.tagColor),
                fontSize: tag.selected ? 20 : 14,
                fontWeight: tag.selected ? FontWeight.bold : null,
              ),
            ),
          ),
        );
      },
    );
    return _buttons;
  }

  Future<List<Tag>> _tagsList() async {
    return Provider.of<ItemProvider>(context, listen: false).getTags();
  }

  @override
  void initState() {
    _getTags = _tagsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getTags,
      builder: (ctx, snap) {
        switch (snap.connectionState) {
          case ConnectionState.active:
            return LinearProgressIndicator();
          case (ConnectionState.done):
            if (snap.hasError) {
              return Text(snap.error as String);
            } else {
              List<Tag> _list = <Tag>[];
              _list = snap.data as List<Tag>;
              if (_list.length < 1) return Container(height: 0);
              return Container(
                height: 48,
                width: double.infinity,
                margin: EdgeInsets.only(top: 8.0, left: 16.0),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: _tags(_list)!,
                ),
              );
            }
          default:
            return LinearProgressIndicator();
        }
      },
    );
  }
}
