import 'package:cpnta/globals.dart';
import 'package:flutter/material.dart';

import '../models/note.dart';

class NoteScreen extends StatefulWidget {
  final Note note;

  const NoteScreen({
    super.key,
    required this.note,
  });

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.note.title;
    contentController.text = widget.note.content;
  }

  void _onFabPressed() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appName),
      ),
      body: Container(
        margin: const EdgeInsets.all(32.0),
        child: Column(children: [
          TextField(
            controller: titleController,
            maxLines: 1,
            decoration: const InputDecoration(
              hintText: "Title",
              border: InputBorder.none,
            ),
            style: Theme.of(context).textTheme.headline5,
          ),
          const SizedBox(height: 10.0),
          TextField(
            controller: contentController,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: "Body",
              border: InputBorder.none,
            ),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onFabPressed,
        child: const Icon(Icons.save),
      ),
    );
  }
}
