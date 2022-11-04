import 'dart:convert';
import 'dart:math';

import 'package:cpnta/constants.dart';
import 'package:cpnta/providers/db_provider.dart';
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

Future<List<Note>> fetchNotes() async {
  bool isOnline = await hasNetwork();
  if (!isOnline) {
    return (await dbProvider.getDataBase()).noteDao.getAllNotes();
  }
  http.Response response =
      await http.get(await getUri(), headers: await getHeaders());
  var responseJson = json.decode(response.body);
  List<Note> notes =
      (responseJson as List).map((p) => Note.fromJson(p)).toList();
  dbProvider.getDataBase().then((db) => db.noteDao.insertNotes(notes));
  return notes;
}

Future<http.Response> createNote(String title, String content) async {
  dbProvider.getDataBase().then((db) async => {
        db.noteDao.insertNote(Note(
            id: Random().nextInt(2 ^ 52),
            title: title,
            content: content,
            createdAt: "",
            modifiedAt: "",
            token: await getToken()))
      });
  return await http.post(await getUri(),
      headers: await getHeaders(),
      body: json.encode({"title": title, "content": content}));
}

Future<http.Response> updateNote(Note note) async {
  dbProvider.getDataBase().then((db) => {
        db.noteDao.updateNote(note),
      });
  return await http.patch(await getUri(),
      headers: await getHeaders(), body: jsonEncode(note.toJson()));
}

Future<http.Response> deleteNote(int noteId) async {
  dbProvider.getDataBase().then((db) => {
        db.noteDao.deleteNote(noteId),
      });
  return await http.delete(
    Uri.parse("${await getBaseUrl()}/notes/$noteId"),
    headers: await getHeaders(),
  );
}
