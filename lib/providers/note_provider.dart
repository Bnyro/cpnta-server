import 'dart:convert';
import 'package:cpnta/constants.dart';
import 'package:cpnta/enums/commit_type.dart';
import 'package:cpnta/models/commit.dart';
import 'package:cpnta/providers/db_provider.dart';
import 'package:cpnta/utilities/random_int.dart';
import 'package:http/http.dart' as http;
import 'package:cpnta/models/note.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'network_provider.dart';

DbProvider dbProvider = DbProvider();

Future<String> getBaseUrl() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("apiUrl") ?? defaultApiUrl;
}

Future<String> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("token") ?? defaultToken;
}

Future<Uri> getUri() async {
  return Uri.parse("${await getBaseUrl()}/notes");
}

Future<Map<String, String>> getHeaders() async {
  return {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': await getToken()
  };
}

enum x { a }

Future<bool> executeCommits() async {
  bool isOnline = await hasNetwork();
  if (!isOnline) return false;
  final commits =
      await (await dbProvider.getDatabase()).commitDao.getAllCommits();

  if (commits.isEmpty) return false;

  final db = await dbProvider.getDatabase();
  final notes = await db.noteDao.getAllNotes();

  for (final commit in commits) {
    switch (commit.method) {
      case 0:
        {
          // create note
          final note = notes.firstWhere((i) => i.id == commit.noteId);
          await createNote(note.title, note.content);
          break;
        }

      case 1:
        {
          // update note
          final note = notes.firstWhere((i) => i.id == commit.noteId);
          await updateNote(note);
          break;
        }
      case 2:
        {
          // delete note
          await deleteNote(commit.noteId);
          break;
        }
      case 3:
        {
          // clear notes
          await deleteAllNotes();
          break;
        }
    }
  }
  await db.commitDao.clear();
  return true;
}

Future<List<Note>> fetchNotes() async {
  bool isOnline = await hasNetwork();
  var dbNotes = await (await dbProvider.getDatabase()).noteDao.getAllNotes();

  if (!isOnline) {
    return dbNotes;
  }

  bool dirty = await executeCommits();

  final notes = await getAllNotes();

  if (!dirty) return notes;

  dbProvider.getDatabase().then((db) {
    db.noteDao.clear();
    db.noteDao.insertNotes(notes);
  });

  return notes;
}

Future<List<Note>> getAllNotes() async {
  http.Response response =
      await http.get(await getUri(), headers: await getHeaders());
  var responseJson = json.decode(response.body);

  return (responseJson as List).map((p) => Note.fromJson(p)).toList();
}

Future<Note> createNote(String title, String content) async {
  bool isOnline = await hasNetwork();
  if (!isOnline) {
    Note note = Note.empty();
    note.id = getRandomInt();
    note.token = await getToken();
    note.title = title;
    note.content = content;

    final db = await dbProvider.getDatabase();

    db.noteDao.insertNote(note);
    db.commitDao.insertCommit(Commit(note.id!, CommitType.create));
  }
  http.Response response = await http.post(await getUri(),
      headers: await getHeaders(),
      body: json.encode({"title": title, "content": content}));

  Note note = Note.fromJson(json.decode(response.body));
  dbProvider.getDatabase().then((db) => db.noteDao.insertNote(note));

  return Note.fromJson(jsonDecode(response.body));
}

Future<Note> updateNote(Note note) async {
  final db = await dbProvider.getDatabase();
  db.noteDao.updateNote(note);

  final isOnline = await hasNetwork();
  if (!isOnline) db.commitDao.insertCommit(Commit(note.id!, CommitType.update));

  var response = await http.patch(await getUri(),
      headers: await getHeaders(), body: jsonEncode(note.toJson()));
  return Note.fromJson(jsonDecode(response.body));
}

Future<http.Response> deleteNote(int noteId) async {
  final db = await dbProvider.getDatabase();
  db.noteDao.deleteNote(noteId);

  final isOnline = await hasNetwork();

  if (!isOnline) db.commitDao.insertCommit(Commit(noteId, CommitType.delete));

  return await http.delete(
    Uri.parse("${await getBaseUrl()}/notes/$noteId"),
    headers: await getHeaders(),
  );
}

Future<http.Response> deleteAllNotes() async {
  final db = await dbProvider.getDatabase();
  db.noteDao.clear();
  final isOnline = await hasNetwork();
  if (!isOnline)
    db.commitDao.insertCommit(Commit(getRandomInt(), CommitType.clear));
  return await http.delete(
    await getUri(),
    headers: await getHeaders(),
  );
}
