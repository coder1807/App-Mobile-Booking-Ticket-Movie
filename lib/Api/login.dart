import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:movie_app/config.dart';
// import 'package:movie_app/manager/shared_preferences.dart';
import 'package:movie_app/models/user.dart';

Future<User> login(String username, String password) async {
  final String apiUrl = '${AppConfig.MY_URL}/login';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));

      // Kiểm tra trạng thái từ API
      if (data['status'] == 'SUCCESS') {
        // Nếu đăng nhập thành công, trả về đối tượng User
        return User.fromJson(data['data']);
      } else {
        // Nếu đăng nhập không thành công, trả về null hoặc lỗi
        throw Exception(data['message'] ?? 'Đăng nhập thất bại!');
      }
    } else if (response.statusCode == 401) {
      // Nếu đăng nhập không hợp lệ (401 Unauthorized)
      throw Exception('Sai tài khoản hoặc mật khẩu');
    } else {
      // Nếu lỗi không xác định
      throw Exception('Lỗi không xác định: ${response.statusCode}');
    }
  } catch (error) {
    // Xử lý các lỗi kết nối, lỗi API...
    throw Exception('Lỗi khi gọi API: $error');
  }
}
