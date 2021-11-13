import 'package:flutter/material.dart';
import 'package:keyway/widgets/picker/blue_color_picker.dart';
import 'package:keyway/widgets/picker/green_color_picker.dart';
import 'package:keyway/widgets/picker/red_color_picker.dart';
import 'package:provider/provider.dart';

import '../models/tag.dart';
import '../providers/item_provider.dart';

class TagAddScreen extends StatefulWidget {
  static const routeName = '/tag-add';

  @override
  _TagAddScreenState createState() => _TagAddScreenState();
}

class _TagAddScreenState extends State<TagAddScreen> {
  late ItemProvider _items;
  Future<List<Tag>>? _getTags;
  List<Widget>? _chips;
  TextEditingController? ctrler;
  FocusNode? focus;
  bool _empty = true;
  Color _color = Colors.grey;

  void _onChange() => setState(() => _empty = ctrler!.text.isEmpty);

  void _setColor(int color) => setState(() => _color = Color(color));

  void _addTag(BuildContext ctx) {
    Tag _tag = Tag(
      tagName: ctrler!.text.toLowerCase(),
      tagColor: _color.value,
    );
    _items.insertTag(_tag);
    Navigator.of(context).pop(_tag);
  }

  Future<List<Tag>> _tagsList() async => await _items.getTags();

  List<Widget>? _tags(List<Tag> tags) {
    _chips = <Widget>[];
    tags.forEach(
      (tag) {
        _chips!.add(
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
  void initState() {
    _items = Provider.of<ItemProvider>(context, listen: false);
    ctrler = TextEditingController();
    focus = FocusNode();
    focus!.requestFocus();
    _empty = ctrler!.text.isEmpty;
    _getTags = _tagsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  '# ' + ctrler!.text,
                  style: TextStyle(
                    color: _color,
                    fontSize: 32,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: TextField(
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
                ),
              ),
              Column(
                children: [
                  RedColorPicker(_color, _setColor),
                  GreenColorPicker(_color, _setColor),
                  BlueColorPicker(_color, _setColor),
                ],
              ),
              FutureBuilder(
                  future: _getTags,
                  builder: (ctx, snap) {
                    switch (snap.connectionState) {
                      case ConnectionState.done:
                        List<Tag> tags = <Tag>[];
                        tags = snap.data as List<Tag>;
                        return Wrap(
                          alignment: WrapAlignment.center,
                          children: _tags(tags)!,
                        );
                      default:
                        return Center(child: CircularProgressIndicator());
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
