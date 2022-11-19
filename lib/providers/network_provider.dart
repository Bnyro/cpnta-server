import 'dart:io';

import 'package:cpnta/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> hasNetwork() async {
  final prefs = await SharedPreferences.getInstance();
  final apiUrl = await prefs.getString("apiUrl") ?? defaultApiUrl;
  try {
    final result = await InternetAddress.lookup(apiUrl);
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}
