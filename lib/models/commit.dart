import 'package:floor/floor.dart';

@entity
class Commit {
  @PrimaryKey(autoGenerate: false)
  final int noteId;
  final int method;

  const Commit(this.noteId, this.method);
}
