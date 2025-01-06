import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      // Bắt đầu đăng nhập Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // Người dùng hủy đăng nhập
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
        await _saveUserToMySQL(user);
      }
      final response = await fetchUserByEmail(user!.email!);
      return response;
    } catch (e) {
      print(e.toString());
      return {};
    }
  }
}

Future<void> _saveUserToMySQL(User user) async {
  final String apiUrl = '${dotenv.env['MY_URL']}/save_oauth_user';
  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': user.email,
          'username': user.email != null ? user.email!.split("@")[0] : "User",
          'fullname': user.displayName,
          'provider': 'Google',
          'dateOfBirth': user.metadata.creationTime?.toIso8601String(),
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
