import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/Api/user/update.dart';
import 'package:movie_app/manager/UserProvider.dart';
import 'package:movie_app/models/user.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>> login(String username, String password) async {
  final String apiUrl = '${dotenv.env['MY_URL']}/login';
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

Future<bool> isLogined() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getInt("user_id") != null) return true;
  return false;
}

Future<void> loadUser(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getInt("user_id") != null) {
    Map<String, dynamic> response = await getInfoUser(prefs.getInt("user_id")!);
    User user = User.fromJson(response);
    await saveLogin(context, user);
  }
}

Future<void> saveLogin(BuildContext context, user) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt("user_id", user.id);
  if (user.fullname != null) prefs.setString("user_fullname", user.fullname!);
Future<Map<String, dynamic>> fetchUserByEmail(String email) async {
  final String apiUrl = '${dotenv.env['MY_URL']}/user/$email';
  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
    );

    // Kiểm tra nếu response không thành công
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data;
    } else {
      print('Failed to load user: ${response.statusCode}');
      return {};
    }
  } catch (error) {
    print('Error fetching user: $error');
    return {};
  }
}

Future<void> saveLogin(
    BuildContext context, Map<String, dynamic> response) async {
  User user = User.fromJson(response['data']['user']);
  Provider.of<UserProvider>(context, listen: false).setUser(user);
}
