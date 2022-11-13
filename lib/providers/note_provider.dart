import 'dart:convert';
import 'dart:math';

import 'package:cpnta/constants.dart';
import 'package:cpnta/providers/db_provider.dart';
import 'package:flutter/material.dart';
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
  var dbNotes = await (await dbProvider.getDatabase()).noteDao.getAllNotes();

  if (!isOnline) {
    return dbNotes;
  }

  bool dirty = false;

  var onlineNotes = await getAllNotes();

  for (var dbNote in dbNotes) {
    if (onlineNotes.where((i) => dbNote.id == i.id).isEmpty) {
      dirty = true;
      debugPrint(dbNote.id.toString());
      await createNote(dbNote.title, dbNote.content);
    }
  }

  if (dirty) {
    onlineNotes = await getAllNotes();
  }

  dbProvider.getDatabase().then((db) {
    db.noteDao.clear();
    db.noteDao.insertNotes(onlineNotes);
  });

  return onlineNotes;
}

Future<List<Note>> getAllNotes() async {
  http.Response response =
      await http.get(await getUri(), headers: await getHeaders());
  var responseJson = json.decode(response.body);

  return (responseJson as List).map((p) => Note.fromJson(p)).toList();
}

Future<http.Response?> createNote(String title, String content) async {
  bool isOnline = await hasNetwork();
  if (!isOnline) {
    Note note = Note.empty();
    note.id = Random().nextInt(100000);
    note.token = await getToken();
    note.title = title;
    note.content = content;

    dbProvider.getDatabase().then((db) async => {db.noteDao.insertNote(note)});
    return null;
  }
  http.Response response = await http.post(await getUri(),
      headers: await getHeaders(),
      body: json.encode({"title": title, "content": content}));

  Note note = Note.fromJson(json.decode(response.body));
  dbProvider.getDatabase().then((db) => {db.noteDao.insertNote(note)});

  return response;
}

Future<http.Response> updateNote(Note note) async {
  dbProvider.getDatabase().then((db) => {
        db.noteDao.updateNote(note),
      });
  return await http.patch(await getUri(),
      headers: await getHeaders(), body: jsonEncode(note.toJson()));
}

Future<http.Response> deleteNote(int noteId) async {
  dbProvider.getDatabase().then((db) => {
        db.noteDao.deleteNote(noteId),
      });
  return await http.delete(
    Uri.parse("${await getBaseUrl()}/notes/$noteId"),
    headers: await getHeaders(),
  );
}

Future<http.Response> deleteAllNotes() async {
  dbProvider.getDatabase().then((db) => db.noteDao.clear());
  return await http.delete(
    await getUri(),
    headers: await getHeaders(),
  );
}
