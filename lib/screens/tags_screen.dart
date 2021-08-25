import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/models/tag.dart';
import 'package:keyway/widgets/loading_scaffold.dart';

class TagsScreen extends StatefulWidget {
  static const routeName = '/tags';

  @override
  _TagsScreenState createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  ItemProvider _item;
  Future<List<Tag>> _getTags;

  Future<List<Tag>> _getTagsAsync() => _item.getTags();

  Future<void> _deleteTag(Tag t) async {
    await _item.deleteTag(t);
    _getTags = _getTagsAsync();
    setState(() {});
  }

  @override
  void initState() {
    _item = Provider.of<ItemProvider>(context, listen: false);
    _getTags = _getTagsAsync();
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
      body: FutureBuilder(
          future: _getTags,
          builder: (ctx, snap) {
            switch (snap.connectionState) {
              case ConnectionState.waiting:
                return LoadingScaffold();
                break;
              case ConnectionState.done:
                return ListView.builder(
                    padding: EdgeInsets.all(12.0),
                    itemCount: snap.data.length,
                    itemBuilder: (ctx, i) {
                      return Card(
                        child: ListTile(
                          leading: Icon(
                            Icons.tag,
                            size: 32,
                            color: Color(snap.data[i].tagColor),
                          ),
                          title: Text(
                            snap.data[i].tagName,
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(snap.data[i].tagColor),
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () => _deleteTag(snap.data[i]),
                            icon: Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                              size: 32,
                            ),
                          ),
                        ),
                      );
                    });
              default:
                return Text('default');
            }
          }),
    );
  }
}
