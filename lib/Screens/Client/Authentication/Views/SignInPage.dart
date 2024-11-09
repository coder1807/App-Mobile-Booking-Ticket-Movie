import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_app/Screens/Components/CustomButton.dart';
import 'package:movie_app/Screens/Components/CustomInput.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
            padding: const EdgeInsets.symmetric(
                horizontal: 32, vertical: 30), // Chỉ đệm hai bên
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Căn trái cho tất cả nội dung
              children: [
                Align(
                  alignment: Alignment.centerRight,
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
                const SizedBox(height: 100),
                Text(
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
                    hintTextColor: Color(0xFFA6A6A6),
                    controller: usernameController,
                    pathImage: 'assets/icons/mail.png'),
                const SizedBox(height: 30),
                CustomInput(
                  hintText: 'Password',
                  hintTextColor: Color(0xFFA6A6A6),
                  controller: passwordController,
                  pathImage: 'assets/icons/lock.png',
                  isPassword: true,
                ),
                const SizedBox(height: 10),
                _forgotPasswordText(),
                const SizedBox(height: 50),
                CustomButton(text: 'Sign In', onPressed: () {}),
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
                  // Căn giữa nội dung của hàng
                  children: [
                    Text(
                      "Don't you have an account?",
                      // Căn giữa đoạn văn bản đầu tiên
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff979797),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    )
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
      alignment: Alignment.centerRight, // Căn chữ sang bên phải
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
