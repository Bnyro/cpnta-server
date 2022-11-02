import 'package:cpnta/globals.dart';
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
  void _onFabPressed() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NoteScreen(
              note: Note(
                  id: null,
                  content: "",
                  title: "",
                  createdAt: "",
                  modifiedAt: "",
                  token: ""),
              isNew: true,
            )));
  }

  final _notes = fetchNotes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appName),
      ),
      body: Center(
          child: FutureBuilder<List<Note>>(
        future: _notes,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          return GridView.count(
            crossAxisCount: 2,
            children: List.generate(snapshot.requireData.length, (index) {
              return NoteWidget(note: snapshot.requireData[index]);
            }),
          );
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: _onFabPressed,
        child: const Icon(Icons.add),
      ),
    );
  }
}
