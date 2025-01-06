import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<List<Map<String, dynamic>>> fetchCommentsByBlogID(int blogID) async {
  final String apiUrl = '${dotenv.env['MY_URL']}/comments/${blogID}';
  if (apiUrl.isEmpty) {
    throw Exception('API URL is not defined in .env file');
  }

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
    );
    try {
      final data = jsonDecode(response.body);
      print(data);
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

Future<bool> submitComment(Map<String, dynamic> ratingDTO) async {
  final String apiUrl = '${dotenv.env['MY_URL']}/comment';
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(ratingDTO),
    );
    return response.statusCode == 200;
  } catch (error) {
    print('Error occurred: $error');
    return false;
  }
}