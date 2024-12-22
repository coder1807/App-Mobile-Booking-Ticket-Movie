import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/Screens/Client/Main/Model/ScheduleItem.dart';

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

Future<List<Map<String, dynamic>>> fetchRatingByMovies(int movieId) async {
  final String apiUrl = '${dotenv.env['MY_URL']}/rating/$movieId';
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

Future<bool> submitRating(Map<String, dynamic> ratingDTO) async {
  final String apiUrl = '${dotenv.env['MY_URL']}/rating';
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(ratingDTO),
    );
    return response.statusCode == 200;
  } catch (error) {
    print('Error occurred: $error');
    return false;
  }
}

Future<List<Map<String, dynamic>>> fetchCinemasByMovie(int movieId) async {
  final String apiUrl = '${dotenv.env['MY_URL']}/cinema?movieId=$movieId';
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

Future<List<ScheduleItem>> fetchSchedulesByMovieAndCinema(
    int cinemaId, int movieId) async {
  final String apiUrl =
      '${dotenv.env['MY_URL']}/schedule?cinemaId=$cinemaId&movieId=$movieId';
  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ScheduleItem.fromJson(json)).toList();
    } else {
      print('Error: ${response.statusCode}');
      return [];
    }
  } catch (error) {
    print('Error occurred: $error');
    return [];
  }
}
