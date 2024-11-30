// ignore: file_names
import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String hintText;
  final String pathImage;
  final Color hintTextColor;
  final Color backgroundColor;
  final Color textColor;
  final TextEditingController controller;
  final bool isPassword;
  const CustomInput({
    super.key,
    required this.hintText,
    required this.hintTextColor,
    required this.controller,
    required this.pathImage,
    this.isPassword = false,
    this.backgroundColor = const Color(0xff2A2A2A),
    this.textColor = const Color(0xFFFFFFFF),
  });

  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: backgroundColor));
    return TextField(
      style: TextStyle(color: textColor, fontSize: 20, fontFamily: 'Poppins'),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: hintTextColor),
        enabledBorder: border,
        focusedBorder: border,
        filled: true,
        fillColor: backgroundColor,
        // ignore: unnecessary_null_comparison
        prefixIcon: pathImage != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: Image.asset(pathImage, fit: BoxFit.contain),
                ),
              )
            : null,
      ),
      obscureText: isPassword,
    );
  }
}
