import 'package:floor/floor.dart';

@Entity(tableName: "Commits")
class Commit {
  @PrimaryKey(autoGenerate: false)
  final int noteId;
  final int method;

  const Commit(this.noteId, this.method);
}
