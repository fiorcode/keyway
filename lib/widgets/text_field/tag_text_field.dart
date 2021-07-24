import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/models/tag.dart';

class TagTextField extends StatefulWidget {
  @override
  _TagTextFieldState createState() => _TagTextFieldState();
}

class _TagTextFieldState extends State<TagTextField> {
  ItemProvider _items;
  TextEditingController ctrler;
  FocusNode focus;

  bool _empty = true;

  void _onChange() => setState(() => _empty = ctrler.text.isEmpty);

  void _addTag(BuildContext ctx) {
    Tag _tag = Tag(ctrler.text.toLowerCase());
    _items = Provider.of<ItemProvider>(context, listen: false);
    _items.insertTag(_tag);
    Navigator.of(context).pop(_tag);
  }

  @override
  void initState() {
    ctrler = TextEditingController();
    focus = FocusNode();
    focus.requestFocus();
    _empty = ctrler.text.isEmpty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      controller: ctrler,
      focusNode: focus,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 3),
        ),
        filled: true,
        fillColor: Theme.of(context).backgroundColor,
        labelText: 'New Tag',
        suffixIcon: _empty
            ? null
            : InkWell(
                child: Icon(Icons.add),
                onTap: () => _addTag(context),
              ),
      ),
      maxLength: 64,
      onChanged: (_) => _onChange(),
    );
  }
}
