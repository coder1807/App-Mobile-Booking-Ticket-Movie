// import 'dart:convert';

// import 'package:movie_app/config.dart';
// import 'package:http/http.dart' as http;

// Future<Map<String, dynamic>> register(
//     String username, String password, String email) async {
//   final String apiUrl = '${AppConfig.MY_URL}/register';
//   try {
//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(
//           {'username': username, 'password': password, 'email': email}),
//     );
//     final data = jsonDecode(utf8.decode(response.bodyBytes));
//     return data;
//   } catch (error) {
//     return {"status": "ERROR", "message": "Lỗi khi gọi API: $error"};
//   }
// }
