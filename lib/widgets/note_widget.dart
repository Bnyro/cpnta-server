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
  Offset _tapPosition = Offset.zero;
  void _getTapPosition(TapDownDetails details) {
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = referenceBox.globalToLocal(details.globalPosition);
    });
  }

  void _deleteNote() {
    deleteNote(widget.note.id!).then((value) => {
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
        });
  }

  void _showContextMenu(BuildContext context) async {
    final RenderObject? overlay =
        Overlay.of(context)?.context.findRenderObject();

    final result = await showMenu(
        context: context,

        // Show the context menu at the tap location
        position: RelativeRect.fromRect(
            Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 30, 30),
            Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
                overlay.paintBounds.size.height)),

        // set a list of choices for the context menu
        items: [
          const PopupMenuItem(
            value: 'delete',
            child: Text('Delete'),
          )
        ]);

    // Implement the logic for each choice here
    switch (result) {
      case 'delete':
        _deleteNote();
        break;
    }
  }

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
        onLongPress: () => _showContextMenu(context),
        onTapDown: (details) => _getTapPosition(details),
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
