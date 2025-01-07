import 'package:flutter/material.dart';
import 'package:movie_app/Api/auth/forgot-password.dart';
import 'package:movie_app/Screens/Components/CustomButton.dart';
import 'package:movie_app/Screens/Components/CustomInput.dart'; // Giả sử bạn đã có phương thức forgotPassword

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF121011), // Màu nền tối như trong SignInPage
      body: _page(),
    );
  }

  Widget _page() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 24, vertical: 20), // Padding giống SignInPage
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Skip text ở góc trên bên phải
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Quay lại trang đăng nhập
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
                  'Quên mật khẩu',
                  style: TextStyle(
                    fontSize: 22, // Kích thước font cho title
                    color: Color(0xffFFFFFF),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                    height: 30), // Giảm khoảng cách giữa title và form
                CustomInput(
                  // Input cho email
                  hintText: 'Email',
                  hintTextColor: const Color(0xFFA6A6A6),
                  controller: _emailController,
                  pathImage: 'assets/icons/mail.png', // Biểu tượng email
                ),
                const SizedBox(height: 12), // Giảm khoảng cách
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 14), // Kích thước font nhỏ cho lỗi
                  ),
                const SizedBox(
                    height: 20), // Giảm khoảng cách giữa lỗi và button
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Center(
                        // Center nút như trong trang đăng nhập
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.6, // Giới hạn nút chiếm 80% chiều rộng màn hình
                          child: CustomButton(
                            text: 'Gửi email',
                            onPressed: () async {
                              final email = _emailController.text.trim();
                              if (email.isNotEmpty) {
                                setState(() {
                                  _isLoading = true;
                                  _errorMessage =
                                      null; // Xóa lỗi cũ khi bắt đầu lại
                                });

                                try {
                                  // Gọi phương thức quên mật khẩu
                                  await forgotPassword(email);

                                  // Hiển thị SnackBar thông báo thành công
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Email khôi phục mật khẩu đã được gửi!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } catch (e) {
                                  // Hiển thị lỗi nếu có vấn đề khi gửi email
                                  setState(() {
                                    _errorMessage =
                                        'Có lỗi xảy ra, vui lòng thử lại!';
                                  });
                                } finally {
                                  setState(() {
                                    _isLoading =
                                        false; // Đặt lại isLoading thành false sau khi xong
                                  });
                                }
                              } else {
                                setState(() {
                                  _errorMessage = 'Vui lòng nhập email!';
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
                      'Bạn đã nhớ mật khẩu? ',
                      style: TextStyle(
                        fontSize: 14, // Kích thước font nhỏ
                        color: Color(0xff979797),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Quay lại trang đăng nhập
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
