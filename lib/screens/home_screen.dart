import 'package:cpnta/constants.dart';
import 'package:cpnta/screens/settings_screen.dart';
import 'package:flutter/material.dart';

import '../models/note.dart';
import '../providers/note_provider.dart';
import '../widgets/note_widget.dart';
import 'note_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _notes = fetchNotes();

  void _onFabPressed() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NoteScreen(
              note: Note.empty(),
              isNew: true,
              refreshNotes: _refreshNotes,
            )));
  }

  void _onSettingsClicked() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SettingsScreen(),
    ));
  }

  Future<void> _refreshNotes() async {
    var notes = await fetchNotes();
    setState(() {
      _notes = Future.value(notes);
    });
  }

  void _deleteNote(Note note) {
    deleteNote(note.id!).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Note deleted!'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              createNote(note.title, note.content)
                  .then((value) => _refreshNotes());
            },
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(appName),
        actions: [
          IconButton(
              icon: const Icon(Icons.settings), onPressed: _onSettingsClicked)
        ],
      ),
      body: RefreshIndicator(
          onRefresh: _refreshNotes,
          child: Center(
            child: FutureBuilder<List<Note>>(
                future: _notes,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.requireData.isEmpty) {
                    return Text(
                      "No notes yet!",
                      style: Theme.of(context).textTheme.headline4,
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.requireData.length,
                        itemBuilder: (context, index) {
                          final note = snapshot.requireData[index];
                          return Dismissible(
                              key: Key(note.id.toString()),
                              onDismissed: ((direction) {
                                setState(() {
                                  snapshot.requireData.removeAt(index);
                                  _deleteNote(note);
                                });
                              }),
                              child: NoteWidget(
                                note: note,
                                refreshNotes: _refreshNotes,
                              ));
                        });
                  }
                }),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: _onFabPressed,
        child: const Icon(Icons.add),
      ),
    );
  }
}
