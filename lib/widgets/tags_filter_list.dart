import 'package:flutter/material.dart';

import 'package:keyway/models/tag.dart';

class TagsFilterList extends StatefulWidget {
  const TagsFilterList(this.tags, this.tagsSwitch);

  final List<Tag> tags;
  final Function tagsSwitch;

  @override
  _TagsFilterListState createState() => _TagsFilterListState();
}

class _TagsFilterListState extends State<TagsFilterList> {
  List<Widget> _chips;

  List<Widget> _tags() {
    _chips = <Widget>[];
    widget.tags.forEach(
      (tag) {
        _chips.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Chip(
              backgroundColor: Colors.grey,
              label: Text(
                tag.tagName,
                style: TextStyle(color: Colors.white),
              ),
              elevation: 8.0,
            ),
          ),
        );
      },
    );
    return _chips;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: double.infinity,
      margin: EdgeInsets.only(top: 8.0, left: 16.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              backgroundColor: Colors.red[200],
              selected: deleted,
              selectedColor: Colors.red,
              onSelected: (_) => deletedSwitch(),
              label: Text(
                'Deleted',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: deleted ? FontWeight.bold : null,
                ),
              ),
              elevation: deleted ? 8.0 : 0.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              backgroundColor: Colors.grey,
              selected: oldPassword,
              selectedColor: Colors.grey[200],
              onSelected: (_) => oldPasswordSwitch(),
              label: Text(
                'With old passwords',
                style: TextStyle(
                  color: oldPassword ? Colors.grey : Colors.white,
                  fontWeight: oldPassword ? FontWeight.bold : null,
                ),
              ),
              elevation: oldPassword ? 8.0 : 0.0,
            ),
          ),
        ],
      ),
    );
  }
}
