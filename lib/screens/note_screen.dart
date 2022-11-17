import 'package:cpnta/constants.dart';
import 'package:cpnta/providers/note_provider.dart';
import 'package:flutter/material.dart';

import '../models/note.dart';
import '../utilities/date_parser.dart';

// ignore: must_be_immutable
class NoteScreen extends StatefulWidget {
  Note note;
  bool isNew;
  final VoidCallback refreshNotes;

  NoteScreen({
    super.key,
    required this.note,
    required this.isNew,
    required this.refreshNotes,
  });

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  bool isDirty = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.note.title;
    contentController.text = widget.note.content;
    titleController.addListener(() {
      _onControllerListenerInvocation();
    });
    contentController.addListener(() {
      _onControllerListenerInvocation();
    });
  }

  void _onControllerListenerInvocation() {
    final dirty = widget.note.title != titleController.text ||
        widget.note.content != contentController.text;
    setState(() {
      isDirty = dirty;
    });
  }

  void _onFabPressed() async {
    if (titleController.text != "" || contentController.text != "") {
      setState(() {
        widget.note.title = titleController.text;
        widget.note.content = contentController.text;
      });

      var note = widget.isNew
          ? await createNote(titleController.text, contentController.text)
          : await updateNote(widget.note);

      final succesText = widget.isNew
          ? "Succesfully created the note!"
          : "Succesfully updated the note!";

      widget.isNew = false;

      if (note.createdAt != "") note.createdAt = widget.note.createdAt;
      widget.note = note;
      widget.refreshNotes();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(succesText),
      ));
    }
  }

  void _deleteNote() {
    deleteNote(widget.note.id!).then((value) {
      widget.refreshNotes();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Note deleted!'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              createNote(widget.note.title, widget.note.content)
                  .then((value) => widget.refreshNotes());
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
          IconButton(onPressed: _deleteNote, icon: const Icon(Icons.delete))
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
      floatingActionButton: isDirty
          ? FloatingActionButton(
              onPressed: _onFabPressed,
              child: const Icon(Icons.save),
            )
          : null,
    );
  }
}
