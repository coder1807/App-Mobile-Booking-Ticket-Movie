import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// Future<void> resetPassword(String token, String newPassword) async {
//   final String apiUrl = '${dotenv.env['MY_URL']}/reset-password';
//   try {
//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         'token': token,
//         'newPassword': newPassword,
//       }),
//     );

//     if (response.statusCode == 200) {
//       // Xử lý khi thành công
//       print('Đặt lại mật khẩu thành công!');
//     } else {
//       // Nếu có lỗi
//       print('Lỗi: ${response.body}');
//     }
//   } catch (e) {
//     // Lỗi kết nối
//     print('Lỗi khi gửi yêu cầu: $e');
//   }
// }

Future<void> forgotPassword(String email) async {
  final String apiUrl = '${dotenv.env['MY_URL']}/forgot-password';
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {'email': email},
    );

    if (response.statusCode == 200) {
      // Xử lý khi thành công, thông báo cho người dùng
      print('Đã gửi email khôi phục mật khẩu!');
    } else {
      // Nếu có lỗi, hiển thị thông báo
      print('Lỗi: ${response.body}');
    }
  } catch (e) {
    // Lỗi kết nối
    print('Lỗi khi gửi yêu cầu: $e');
  }
}
