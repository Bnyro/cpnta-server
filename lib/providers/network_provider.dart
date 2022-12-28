import 'package:http/http.dart' as http;
import 'package:cpnta/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> hasNetwork() async {
  final prefs = await SharedPreferences.getInstance();
  final apiUrl = await prefs.getString("apiUrl") ?? defaultApiUrl;
  try {
    final response = await http.get(Uri.parse(apiUrl));
    return response.statusCode == 200;
  } on Exception catch (_) {
    return false;
  }
}
