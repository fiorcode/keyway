import 'package:flutter/material.dart';
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
  ItemProvider _item;
  Future<void> _getNotes;
  List<Note> _notes;

  Future<void> _getNotesAsync() async {
    ItemProvider _ip = Provider.of<ItemProvider>(context, listen: false);
    _notes = await _ip.fetchNotes();
    CriptoProvider _cp = Provider.of<CriptoProvider>(context, listen: false);
    Future.forEach(_notes, (n) async => await _cp.decryptNote(n));
  }

  Future<void> _deleteNote(Note n) async {
    ItemProvider _ip = Provider.of<ItemProvider>(context, listen: false);
    await _ip.deleteNote(n);
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
                break;
              case ConnectionState.done:
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
