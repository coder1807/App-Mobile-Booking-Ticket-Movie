import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<List<Map<String, dynamic>>> fetchMovies() async {
  final String apiUrl = '${dotenv.env['MY_URL']}/movies';

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      print('Error: ${response.statusCode}');
      return [];
    }
  } catch (error) {
    print('Error occurred: $error');
    return [];
  }
}

Future<List<Map<String, dynamic>>> fetchMoviesByScheduleId(int id) async {
  final String apiUrl = '${dotenv.env['MY_URL']}/movie?scheduleId=$id';

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      print('Error: ${response.statusCode}');
      return [];
    }
  } catch (error) {
    print('Error occurred: $error');
    return [];
  }
}

Future<Map<String, dynamic>> fetchSchedulesById(int id) async {
  final String apiUrl = '${dotenv.env['MY_URL']}/schedules/$id';
  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Map<String, dynamic>.from(data);
    } else {
      print('Error: ${response.statusCode}');
      return {};
    }
  } catch (error) {
    print('Error occurred: $error');
    return {};
  }
}

Future<Map<String, dynamic>> fetchCinemaBySchedule(int scheduleId) async {
  final String apiUrl = '${dotenv.env['MY_URL']}/cinema?scheduleId=$scheduleId';
  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Map<String, dynamic>.from(data);
    } else {
      print('Error: ${response.statusCode}');
      return {};
    }
  } catch (error) {
    print('Error occurred: $error');
    return {};
  }
}
