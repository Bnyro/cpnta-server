import 'package:cpnta/constants.dart';
import 'package:cpnta/providers/note_provider.dart';
import 'package:flutter/material.dart';

import '../models/note.dart';
import '../utilities/date_parser.dart';

class NoteScreen extends StatefulWidget {
  final Note note;
  final bool isNew;
  final VoidCallback refreshNotes;

  const NoteScreen({
    super.key,
    required this.note,
    required this.isNew,
    required this.refreshNotes,
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

  void _onFabPressed() async {
    if (titleController.text != "" || contentController.text != "") {
      setState(() {
        widget.note.title = titleController.text;
        widget.note.content = contentController.text;
      });

      var response = widget.isNew
          ? await createNote(titleController.text, contentController.text)
          : await updateNote(widget.note);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Status code: ${response?.statusCode}"),
      ));
      widget.refreshNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(appName),
        actions: [
          IconButton(
              onPressed: () {
                deleteNote(widget.note.id!).then((response) {
                  widget.refreshNotes();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text("Deleted")));
                });
              },
              icon: const Icon(Icons.delete))
        ],
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
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (widget.note.createdAt != "")
              Text("Created at ${formatTime(widget.note.createdAt)}",
                  style: Theme.of(context).textTheme.caption),
            const SizedBox(height: 5.0),
            if (widget.note.modifiedAt != "")
              Text("Modified at ${formatTime(widget.note.modifiedAt)}",
                  style: Theme.of(context).textTheme.caption)
          ]),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onFabPressed,
        child: const Icon(Icons.save),
      ),
    );
  }
}
