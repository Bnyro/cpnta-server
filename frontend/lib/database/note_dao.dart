import 'package:cpnta/models/note.dart';
import 'package:floor/floor.dart';

@dao
abstract class NoteDao {
  @Query('SELECT * FROM Note')
  Future<List<Note>> getAllNotes();
  @insert
  Future<void> insertNote(Note note);
  @insert
  Future<List<int>> insertNotes(List<Note> notes);
  @update
  Future<void> updateNote(Note note);
  @Query("delete from Note where id = :id")
  Future<void> deleteNote(int id);
  @delete
  Future<int> deleteAll(List<Note> notes);
  @Query('DELETE FROM Note')
  Future<void> clear();
}
