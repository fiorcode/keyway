import 'package:flutter/material.dart';
import 'package:keyway/helpers/error_helper.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/cripto_provider.dart';
import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/models/note.dart';
import 'package:keyway/widgets/loading_scaffold.dart';

class NotesScreen extends StatefulWidget {
  static const routeName = '/notes';

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late ItemProvider _item;
  Future<void>? _getNotes;
  late List<Note> _notes;

  Future<void> _getNotesAsync() async {
    ItemProvider _ip = Provider.of<ItemProvider>(context, listen: false);
    _notes = await _ip.fetchNotes();
    CriptoProvider _cp = Provider.of<CriptoProvider>(context, listen: false);
    Future.forEach(
        _notes,
        (dynamic n) async => await _cp
            .decryptNote(n)
            .onError((error, st) => ErrorHelper.errorDialog(context, error)));
  }

  Future<void> _deleteNote(Note n) async {
    ItemProvider _ip = Provider.of<ItemProvider>(context, listen: false);
    await _ip
        .deleteNote(n)
        .onError((error, st) => ErrorHelper.errorDialog(context, error));
    _getNotes = _getNotesAsync();
    setState(() {});
  }

  @override
  void initState() {
    _getNotes = _getNotesAsync();
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
          future: _getNotes,
          builder: (ctx, snap) {
            switch (snap.connectionState) {
              case ConnectionState.waiting:
                return LoadingScaffold();
              case ConnectionState.done:
                if (snap.hasError) {
                  return ErrorHelper.errorScaffold(snap.error);
                }
                return ListView.builder(
                    padding: EdgeInsets.all(12.0),
                    itemCount: _item.notes.length,
                    itemBuilder: (ctx, i) {
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.http, size: 38),
                          title: Text(_item.notes[i].noteDec),
                          trailing: IconButton(
                            onPressed: () => _deleteNote(_item.notes[i]),
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
