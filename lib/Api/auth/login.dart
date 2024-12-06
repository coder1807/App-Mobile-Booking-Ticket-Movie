import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'package:movie_app/config.dart';
import 'package:movie_app/manager/UserProvider.dart';
// import 'package:movie_app/manager/shared_preferences.dart';
import 'package:movie_app/models/user.dart';
import 'package:provider/provider.dart';

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

Future<void> saveLogin(
    BuildContext context, Map<String, dynamic> response) async {
  User user = User.fromJson(response['data']['user']);
  Provider.of<UserProvider>(context, listen: false).setUser(user);
  print(user);
}
