import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_app/Api/auth/login.dart';
import 'package:movie_app/Screens/Client/Authentication/Views/GetFavoritePage.dart';
import 'package:movie_app/Screens/Client/Authentication/Views/SignUpPage.dart';
import 'package:movie_app/Screens/Components/CustomButton.dart';
import 'package:movie_app/Screens/Components/CustomInput.dart';
import 'package:movie_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121011),
      body: _page(),
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
                            builder: (context) => const GetFavoritePage()),
                      );
                    },
                    child: const Text(
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
                const SizedBox(height: 150),
                const Text(
                  'Sign In',
                  style: TextStyle(
                      fontSize: 22,
                      color: Color(0xffFFFFFF),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 30),
                CustomInput(
                    hintText: 'Username',
                    hintTextColor: const Color(0xFFA6A6A6),
                    controller: usernameController,
                    pathImage: 'assets/icons/mail.png'),
                const SizedBox(height: 30),
                CustomInput(
                  hintText: 'Password',
                  hintTextColor: const Color(0xFFA6A6A6),
                  controller: passwordController,
                  pathImage: 'assets/icons/lock.png',
                  isPassword: true,
                ),
                const SizedBox(height: 10),
                _forgotPasswordText(),
                const SizedBox(height: 50),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        text: 'Sign In',
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
                          setState(() {
                            isLoading = true;
                          });

                          try {
                            final response = await login(
                              usernameController.text.trim(),
                              passwordController.text.trim(),
                            );
                            if (response["status"] == "SUCCESS") {
                              saveLogin(context, response);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(response['message'] ??
                                      'Đăng nhập thành công!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MainPage()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(response['message'] ??
                                      "Đăng nhập thất bại!"),
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
                        },
                      ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xff1E1E1E),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.facebook, color: Colors.white),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xff1E1E1E),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: const FaIcon(FontAwesomeIcons.google,
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
                          color: const Color(0xff1E1E1E),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.apple, color: Colors.white),
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
                    const Text(
                      "Don't you have an account?",
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
                          MaterialPageRoute(
                              builder: (context) => const SignUpPage()),
                        );
                      },
                      child: const Text(
                        'Sign Up',
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
      alignment: Alignment.centerRight,
      child: Text(
        "Forgot Password?",
        style: TextStyle(
            fontSize: 14,
            color: Color(0xffD4D4D4),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
