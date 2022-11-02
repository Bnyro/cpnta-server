import 'package:cpnta/providers/note_provider.dart';
import 'package:cpnta/widgets/note_widget.dart';
import 'package:flutter/material.dart';

import 'models/note.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CPNTA',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'CPNTA'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _onFabPressed() {}

  final _notes = fetchNotes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
