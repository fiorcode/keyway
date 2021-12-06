import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/helpers/error_helper.dart';
import 'package:keyway/models/tag.dart';
import 'package:keyway/widgets/empty_items.dart';

class TagTableScreen extends StatefulWidget {
  static const routeName = '/tag-table';

  @override
  _TagTableScreenState createState() => _TagTableScreenState();
}

class _TagTableScreenState extends State<TagTableScreen> {
  Future<List<Tag>>? _getTags;

  Future<List<Tag>> _getTagsAsync() =>
      Provider.of<ItemProvider>(context, listen: false).getTags();

  @override
  void initState() {
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
        title: Text('tag table', style: TextStyle(color: Colors.grey)),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _getTags,
        builder: (ctx, snap) {
          switch (snap.connectionState) {
            case ConnectionState.none:
              return Center(child: Text('none'));
            case (ConnectionState.waiting):
              return Center(child: CircularProgressIndicator());
            case (ConnectionState.done):
              if (snap.hasError) {
                return ErrorHelper.errorBody(snap.error);
              } else {
                List<Tag> tags = <Tag>[];
                tags = snap.data as List<Tag>;
                return tags.length <= 0
                    ? EmptyItems()
                    : ListView.separated(
                        itemCount: tags.length,
                        itemBuilder: (ctx, i) => ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('tag_id: '),
                                  Text(
                                    tags[i].id.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('tag_name: '),
                                  Expanded(
                                    child: Text(
                                      tags[i].tagName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('tag_color: '),
                                  Expanded(
                                    child: Text(
                                      tags[i].tagColor.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        separatorBuilder: (ctx, i) =>
                            Divider(color: Colors.black),
                      );
              }
            default:
              return Center(child: Text('default'));
          }
        },
      ),
    );
  }
}
