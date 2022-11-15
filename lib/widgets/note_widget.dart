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
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NoteScreen(
                    note: widget.note,
                    isNew: false,
                    refreshNotes: widget.refreshNotes,
                  )));
        },
        child: Card(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.note.title != "")
                      Text(widget.note.title,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.titleMedium),
                    if (widget.note.title != "" && widget.note.content != "")
                      const SizedBox(height: 2),
                    if (widget.note.content != "")
                      Text(
                        widget.note.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ))));
  }
}
