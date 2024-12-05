import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/Api/auth/register.dart';
import 'package:movie_app/Screens/Client/Authentication/Views/SignInPage.dart';
import 'package:movie_app/Screens/Components/CustomInput.dart';
import 'package:movie_app/Screens/Components/CustomButton.dart';
import 'package:movie_app/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:movie_app/models/user.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  String dbDate = "";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Color(0xFF121011),
        body: _page(),
      ),
    );
  }

  Widget _page() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInPage()),
                      );
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Color(0xffD4D4D4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Sign Up',
                  style: TextStyle(
                      fontSize: 22,
                      color: Color(0xffFFFFFF),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 30),
                CustomInput(
                    hintText: 'Username',
                    hintTextColor: Color(0xFFA6A6A6),
                    controller: usernameController,
                    pathImage: 'assets/icons/user.png'),
                const SizedBox(height: 30),
                CustomInput(
                  hintText: 'Email',
                  hintTextColor: Color(0xFFA6A6A6),
                  controller: emailController,
                  pathImage: 'assets/icons/mail.png',
                ),
                const SizedBox(height: 30),
                CustomInput(
                  hintText: 'Password',
                  hintTextColor: Color(0xFFA6A6A6),
                  controller: passwordController,
                  pathImage: 'assets/icons/lock.png',
                  isPassword: true,
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () async {
                    await _pickDate(context); // Gọi hàm xử lý DatePicker
                  },
                  child: AbsorbPointer(
                    child: CustomInput(
                      hintText: 'Birthday',
                      hintTextColor: Color(0xFFA6A6A6),
                      controller: birthdayController,
                      pathImage: 'assets/icons/birthday.png',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _forgotPasswordText(),
                const SizedBox(height: 50),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : CustomButton(
                        text: 'Sign Up',
                        onPressed: () async {
                          if (usernameController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Username không được để trống!')),
                            );
                            return;
                          }
                          if (passwordController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Password không được để trống!')),
                            );
                            return;
                          }
                          if (emailController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Email không được để trống!')),
                            );
                            return;
                          }
                          final emailRegex =
                              RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

                          if (!emailRegex
                              .hasMatch(emailController.text.trim())) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Địa chỉ email không hợp lệ!')),
                            );
                            return;
                          }
                          if (birthdayController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Ngày sinh không được để trống!'),
                              ),
                            );
                            return;
                          }
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            final response = await register(
                                usernameController.text.trim(),
                                passwordController.text.trim(),
                                emailController.text.trim(),
                                dbDate);
                            if (response["status"] == "SUCCESS") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(response['message'] ??
                                      'Đăng ký thành công!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignInPage()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(response['message'] ??
                                      "Đăng ký thất bại!"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Có lỗi xảy ra: $error'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Color(0xff1E1E1E),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.facebook, color: Colors.white),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Color(0xff1E1E1E),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: FaIcon(FontAwesomeIcons.google,
                              color: Colors.white),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Color(0xff1E1E1E),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.apple, color: Colors.white),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff979797),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _forgotPasswordText() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "By clicking the 'sign up' button, you accept the terms of the Privacy Policy",
        style: TextStyle(
            fontSize: 12,
            color: Color(0xff979797),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.teal, // Màu tiêu đề và nút "OK"
              onPrimary: Colors.white, // Màu chữ trên nút "OK"
              onSurface: Colors.black, // Màu chữ tiêu đề
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.teal, // Màu nút "CANCEL"
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      // Định dạng ngày hiển thị trong UI
      String displayDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      // Định dạng ngày lưu trữ trong DB
      dbDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        birthdayController.text = displayDate; // Cập nhật UI
      });
    }
  }
}
