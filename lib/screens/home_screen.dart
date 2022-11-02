import 'package:cpnta/globals.dart';
import 'package:flutter/material.dart';

import '../models/note.dart';
import '../providers/note_provider.dart';
import '../widgets/note_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _onFabPressed() {}

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
        tooltip: 'New',
        child: const Icon(Icons.add),
      ),
    );
  }
}
