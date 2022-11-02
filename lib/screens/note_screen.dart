import 'package:cpnta/globals.dart';
import 'package:flutter/material.dart';

import '../models/note.dart';
import '../utilities/date_parser.dart';

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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
          const SizedBox(height: 10.0),
          Opacity(
            opacity: 0.5,
            child: Column(children: [
              Text("Created at ${formatTime(widget.note.createdAt)}"),
              const SizedBox(height: 5.0),
              Text("Modified at ${formatTime(widget.note.modifiedAt)}")
            ]),
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onFabPressed,
        child: const Icon(Icons.save),
      ),
    );
  }
}
