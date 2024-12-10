import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/models/movie.dart';

Future<List<Movie>> getListMovie() async {
  final String apiUrl = '${dotenv.env['MY_URL']}/movies';
  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Movie> movieList = [];
      for (var item in data) {
        movieList.add(Movie.fromJson(item));
      }
      return movieList;
    } else {
      throw Exception('Failed to load movies list');
    }
  } catch (error) {
    log('Lỗi khi gọi API: ${error}');
    return [];
  }
}
