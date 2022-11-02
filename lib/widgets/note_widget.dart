import 'package:cpnta/providers/note_provider.dart';
import 'package:cpnta/screens/note_screen.dart';
import 'package:flutter/material.dart';

import '../models/note.dart';

class NoteWidget extends StatefulWidget {
  final Note note;
  final VoidCallback refreshNotes;

  const NoteWidget({
    super.key,
    required this.note,
    required this.refreshNotes,
  });

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NoteScreen(
                        note: widget.note,
                        isNew: false,
                        refreshNotes: widget.refreshNotes,
                      )))
            },
        onDoubleTap: () => {
              deleteNote(widget.note.id!),
              widget.refreshNotes(),
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Note deleted!'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      createNote(widget.note.title, widget.note.content);
                      widget.refreshNotes();
                    },
                  ),
                ),
              )
            },
        child: Card(
            margin: const EdgeInsets.all(16.0),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.note.title,
                    style: Theme.of(context).textTheme.headline5),
                const SizedBox(height: 10.0),
                Text(
                  widget.note.content,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ))));
  }
}
