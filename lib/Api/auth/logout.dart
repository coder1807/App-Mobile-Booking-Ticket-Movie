import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/config.dart';

import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> logout() async {
  final String apiUrl = '${dotenv.env['MY_URL']}/logout';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    return data;
  } catch (error) {
    return {"status": "ERROR", "message": "Lỗi khi gọi API: $error"};
  }
}
