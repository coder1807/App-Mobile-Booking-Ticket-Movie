import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<List<Map<String, dynamic>>> fetchMovies() async {
  final String apiUrl = '${dotenv.env['MY_URL']}/movies';

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return List<Map<String, dynamic>>.from(data);
    } else {
      print('Error: ${response.statusCode}');
      return [];
    }
  } catch (error) {
    print('Error occurred: $error');
    return [];
  }
}
