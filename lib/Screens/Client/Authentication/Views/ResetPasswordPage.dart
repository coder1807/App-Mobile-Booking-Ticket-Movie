import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/Screens/Client/Authentication/Views/SignInPage.dart';
import 'package:movie_app/Screens/Components/CustomButton.dart';
import 'package:movie_app/Screens/Components/CustomInput.dart'; // Assuming you're using dotenv for environment variables.

class ResetPasswordScreen extends StatefulWidget {
  final String token;

  ResetPasswordScreen({super.key, required this.token});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> resetPassword(String newPassword) async {
    final String apiUrl = '${dotenv.env['MY_URL']}/reset-password';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'token': widget.token,
          'newPassword': newPassword,
        }),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đặt lại mật khẩu thành công!')),
        );
        Navigator.pop(context);
      } else {
        setState(() {
          _errorMessage = response.body;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi kết nối!';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF121011), // Dark background to match SignInPage
      body: _page(),
    );
  }

  Widget _page() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 24, vertical: 20), // Giảm padding tổng thể
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Skip text ở góc trên bên phải
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInPage()));
                      // Navigating back on tap
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 14, // Kích thước font nhỏ
                        color: Color(0xffD4D4D4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                    height: 80), // Giảm khoảng cách giữa Skip và Title
                const Text(
                  'Đặt lại mật khẩu',
                  style: TextStyle(
                    fontSize: 20, // Giảm kích thước font cho title
                    color: Color(0xffFFFFFF),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                    height: 20), // Giảm khoảng cách giữa title và form
                CustomInput(
                  hintText: 'Mật khẩu mới',
                  hintTextColor: const Color(0xFFA6A6A6),
                  controller: _passwordController,
                  pathImage: 'assets/icons/lock.png',
                  isPassword: true,
                ),
                const SizedBox(height: 12), // Giảm khoảng cách
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 14), // Kích thước font nhỏ hơn cho lỗi
                  ),
                const SizedBox(
                    height: 20), // Giảm khoảng cách giữa error và button
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Center(
                        // Center the button to avoid full width
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.6, // Giới hạn width của button (80% màn hình)
                          child: CustomButton(
                            text: 'Đặt lại mật khẩu',
                            onPressed: () async {
                              final newPassword =
                                  _passwordController.text.trim();
                              if (newPassword.isNotEmpty) {
                                setState(() {
                                  _isLoading = true;
                                });
                                await resetPassword(newPassword);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignInPage()));
                              } else {
                                setState(() {
                                  _errorMessage = 'Vui lòng nhập mật khẩu mới!';
                                });
                              }
                            },
                          ),
                        ),
                      ),
                const SizedBox(
                    height: 20), // Giảm khoảng cách giữa button và dòng dưới
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Bạn đã nhớ ra mật khẩu?',
                      style: TextStyle(
                        fontSize: 14, // Kích thước font nhỏ
                        color: Color(0xff979797),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInPage()));
                        ; // Go back to sign-in screen
                      },
                      child: const Text(
                        'Đăng nhập',
                        style: TextStyle(
                          fontSize: 14, // Kích thước font nhỏ
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
