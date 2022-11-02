import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cpnta/globals.dart' as globals;
import 'package:cpnta/models/note.dart';

 Map<String, String> requestHeaders = {
       'Content-type': 'application/json',
       'Accept': 'application/json',
       'Authorization': 'SuperSuperSuperSuper'
     };

Future<List<Note>> fetchNotes() async {
  http.Response response = await http.get(
    Uri.parse("${globals.baseUrl}/notes"),
    headers: requestHeaders
  );
  var responseJson = json.decode(response.body);
  return (responseJson as List)
      .map((p) => Note.fromJson(p))
      .toList();
}