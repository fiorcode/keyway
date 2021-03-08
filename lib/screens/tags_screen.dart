import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/tag.dart';
import '../providers/item_provider.dart';
import '../widgets/empty_items.dart';
import 'tag_add_screen.dart';

class TagsScreen extends StatefulWidget {
  static const routeName = '/tags';

  @override
  _TagsScreenState createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  ItemProvider _items;
  Future<List<Tag>> _getTags;
  bool _deleting = false;

  Future<List<Tag>> _tagsList() async => await _items.getTags();

  void _deleteTag(Tag tag) {
    setState(() => _deleting = true);
    _items.deleteTag(tag).then((_) {
      _deleting = false;
      _getTags = _tagsList();
      setState(() {});
    });
  }

  List<Widget> _tagsListTiles(List<Tag> tags) {
    List<Widget> _tagsList = <Widget>[];
    tags.forEach((_tag) {
      _tagsList.add(
        Card(
          elevation: 4.0,
          child: ListTile(
            leading: Icon(Icons.tag),
            title: Text(_tag.tagName),
            trailing: _deleting
                ? CircularProgressIndicator()
                : IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteTag(_tag),
                  ),
          ),
          shape: StadiumBorder(),
        ),
      );
    });
    return _tagsList;
  }

  void _goToAddTag() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TagAddScreen(),
        ),
      ).then((_) => _onReturn());

  void _onReturn() {
    _getTags = _tagsList();
    setState(() {});
  }

  @override
  void initState() {
    _items = Provider.of<ItemProvider>(context, listen: false);
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
        title: Icon(Icons.tag),
        centerTitle: true,
        actions: [IconButton(icon: Icon(Icons.add), onPressed: _goToAddTag)],
      ),
      body: FutureBuilder(
          future: _getTags,
          builder: (ctx, snap) {
            switch (snap.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
                break;
              case ConnectionState.done:
                return (snap.data as List<Tag>).length > 0
                    ? ListView(
                        padding: EdgeInsets.all(16.0),
                        children: _tagsListTiles(snap.data),
                      )
                    : EmptyItems();
              default:
                return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
