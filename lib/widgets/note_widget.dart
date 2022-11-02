import 'package:flutter/material.dart';

import '../models/note.dart';

class NoteWidget extends StatefulWidget {
  final Note note;

  const NoteWidget({
    super.key,
    required this.note,
  });

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
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
        )));
  }
}
