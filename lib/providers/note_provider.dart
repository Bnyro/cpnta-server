import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cpnta/globals.dart' as globals;
import 'package:cpnta/models/note.dart';

import '../globals.dart';

Uri getUri() {
  return Uri.parse("${globals.baseUrl}/notes");
}

Map<String, String> getHeaders() {
  return {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': token
  };
}

Future<List<Note>> fetchNotes() async {
  http.Response response = await http.get(getUri(), headers: getHeaders());
  var responseJson = json.decode(response.body);
  return (responseJson as List).map((p) => Note.fromJson(p)).toList();
}

Future<http.Response> createNote(String title, String content) async {
  return await http.post(getUri(),
      headers: getHeaders(),
      body: json.encode({"title": title, "content": content}));
}

Future<http.Response> updateNote(Note note) async {
  return await http.patch(getUri(),
      headers: getHeaders(), body: jsonEncode(note.toJson()));
}
