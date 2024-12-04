import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:movie_app/config.dart';
// import 'package:movie_app/manager/shared_preferences.dart';
import 'package:movie_app/models/user.dart';

Future<Map<String, dynamic>> login(String username, String password) async {
  final String apiUrl = '${AppConfig.MY_URL}/login';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    final data = jsonDecode(utf8.decode(response.bodyBytes));
    return data;
  } catch (error) {
    return {"status": "ERROR", "message": "Lỗi khi gọi API: $error"};
  }
}
