import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/Api/auth/login.dart';
import 'package:movie_app/manager/UserProvider.dart';

import 'dart:convert';

import 'package:movie_app/Screens/Client/Main/Views/HomePage.dart';
import 'package:movie_app/main.dart';
import 'package:provider/provider.dart';

class GoogleLoginService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      // Bắt đầu đăng nhập Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return {};
      }

      // Lấy Google ID Token
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      final UserCredential result =
          await auth.signInWithCredential(authCredential);
      final User? user = result.user;
      print('user: $user');
      if (user != null) {
        final userData = await fetchUserByEmail(user.email!);
        if (userData.isEmpty) {
          // Người dùng chưa tồn tại, yêu cầu ngày sinh
          await _showDateOfBirthDialogForGoogle(context, user);
        }
      }
      return user != null ? fetchUserByEmail(user.email!) : {};
    } catch (e) {
      print(e.toString());
      return {};
    }
  }
}

class FacebookLoginService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> signInWithFacebook(BuildContext context) async {
    try {
      // Đăng nhập với Facebook
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;

        // Lấy credential từ Facebook để đăng nhập Firebase
        final OAuthCredential facebookCredential =
            FacebookAuthProvider.credential(accessToken.tokenString);
        final UserCredential userCredential =
            await _auth.signInWithCredential(facebookCredential);

        final User? user = userCredential.user;

        // Lưu người dùng vào MySQL
        if (user != null) {
          final userData = await fetchUserByEmail(user.email!);
          if (userData.isEmpty) {
            // Người dùng chưa tồn tại, yêu cầu ngày sinh
            await _showDateOfBirthDialog(context, user);
          }
        }
        return user != null ? fetchUserByEmail(user.email!) : {};
      } else {
        throw Exception("Đăng nhập Facebook thất bại!");
      }
    } catch (e) {
      print("Facebook login error: $e");
      return {};
    }
  }
}

Future<void> _saveUserGoogle(User user, DateTime dateOfBirth) async {
  final String apiUrl = '${dotenv.env['MY_URL']}/save_oauth_user';
  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': user.email,
          'username': user.email != null ? user.email!.split("@")[0] : "User",
          'fullname': user.displayName,
          'provider': 'Google',
          'dateOfBirth':
              dateOfBirth.toIso8601String(), // Gửi ngày sinh tới backend
        }));
    if (response.statusCode == 200) {
      print('User saved successfully');
    } else {
      print('Failed to save user');
    }
  } catch (error) {
    return;
  }
}

Future<void> _showDateOfBirthDialog(BuildContext context, User user) async {
  DateTime? selectedDate;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Cung cấp ngày sinh"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Vui lòng chọn ngày sinh của bạn."),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  selectedDate = pickedDate;
                  Navigator.of(context).pop(); // Đóng dialog
                }
              },
              child: Text("Chọn ngày sinh"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Đóng dialog
            child: Text("Hủy"),
          ),
        ],
      );
    },
  );

  if (selectedDate != null) {
    // Lưu ngày sinh vào backend
    await _saveUserFacebook(user, selectedDate!);
  }
}

Future<void> _showDateOfBirthDialogForGoogle(
    BuildContext context, User user) async {
  DateTime? selectedDate;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Cung cấp ngày sinh"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Vui lòng chọn ngày sinh của bạn."),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  selectedDate = pickedDate;
                  Navigator.of(context).pop(); // Đóng dialog
                }
              },
              child: Text("Chọn ngày sinh"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Đóng dialog
            child: Text("Hủy"),
          ),
        ],
      );
    },
  );

  if (selectedDate != null) {
    // Lưu ngày sinh vào backend
    await _saveUserGoogle(user, selectedDate!);
  }
}

Future<void> _saveUserFacebook(User user, DateTime dateOfBirth) async {
  final String apiUrl = '${dotenv.env['MY_URL']}/save_oauth_user';
  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': user.email,
          'username': user.email != null ? user.email!.split("@")[0] : "User",
          'fullname': user.displayName,
          'provider': 'Facebook',
          'dateOfBirth':
              dateOfBirth.toIso8601String(), // Gửi ngày sinh tới backend
        }));
    if (response.statusCode == 200) {
      print('User saved successfully');
    } else {
      print('Failed to save user');
    }
  } catch (error) {
    print("MySQL save error: $error");
  }
}
