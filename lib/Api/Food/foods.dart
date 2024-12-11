import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<List<Map<String, dynamic>>> fetchFoods() async {
  final String apiUrl = '${dotenv.env['MY_URL']}/foods';
  if (apiUrl == null || apiUrl.isEmpty) {
    throw Exception('API URL is not defined in .env file');
  }

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
    );
    try {
      final data = jsonDecode(response.body);
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      } else {
        print('Unexpected response format: $data');
        return [];
      }
    } catch (error) {
      print('Failed to parse response: $error');
      return [];
    }
  } catch (error) {
    print('Error occurred: $error');
    return [];
  }
}