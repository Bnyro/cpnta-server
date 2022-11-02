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
  @override
  Widget build(BuildContext context) {
    return const Text("NoteScreen");
  }
}
