import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> updateUser(int id, String fullname, String phone,
    String birthday, String address) async {
  final String apiUrl = '${dotenv.env['MY_URL']}/user/update/$id';
  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fullname': fullname,
        'phone': phone,
        'birthday': birthday,
        'address': address,
      }),
    );

    final data = jsonDecode(utf8.decode(response.bodyBytes));
    return data;
  } catch (error) {
    return {"status": "ERROR", "message": "Lỗi khi gọi API: $error"};
  }
}

Future<Map<String, dynamic>> updatePassword(
    int id, String currentPassword, String newPassword) async {
  final String apiUrl = '${dotenv.env['MY_URL']}/user/change-password/$id';
  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'oldPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    return data;
  } catch (error) {
    return {"status": "ERROR", "message": "Lỗi khi gọi API: $error"};
  }
}
