import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/models/user.dart';
import 'package:movie_app/manager/UserProvider.dart';
import 'package:provider/provider.dart';

import '../../../../../models/movie.dart';

class FavoriteMoviePage extends StatefulWidget {
  const FavoriteMoviePage({super.key});

  @override
  State<FavoriteMoviePage> createState() => _FavoriteMoviePageState();
}
class _FavoriteMoviePageState extends State<FavoriteMoviePage> {
  bool _isLoading = true;
  String? _errorMessage;
  List<int> _favoriteMovieIds = [];
  List<Movie> _favoriteMovies = [];

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final baseUrl = dotenv.env['MY_URL'];
    if (baseUrl == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Base URL is null. Please check the .env file.';
      });
      return;
    }

    try {
      final url = Uri.parse('$baseUrl/user/${user?.id}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final fetchedUser = User.fromJson(jsonResponse);

        setState(() {
          _favoriteMovieIds = fetchedUser.favoriteFilmIds;
        });

        await fetchMovieDetails(); // Fetch movie details after user data.
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load user data. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching user data: $e';
      });
    }
  }

  Future<void> fetchMovieDetails() async {
    final baseUrl = dotenv.env['MY_URL'];
    if (baseUrl == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Base URL is null. Please check the .env file.';
      });
      return;
    }

    try {
      List<Movie> movies = [];
      for (var movieId in _favoriteMovieIds) {
        final url = Uri.parse('$baseUrl/movie/$movieId');
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final movieJson = json.decode(response.body);

          // If the response is a list, take the first movie or process accordingly
          if (movieJson is List) {
            if (movieJson.isNotEmpty) {
              movies.add(Movie.fromJson(movieJson[0])); // Use the first movie in the list
            }
          } else if (movieJson is Map<String, dynamic>) {
            movies.add(Movie.fromJson(movieJson)); // Add single movie object
          } else {
            throw Exception('Unexpected response format for movie ID $movieId.');
          }
        } else {
          throw Exception('Failed to fetch movie details for ID $movieId.');
        }
      }

      setState(() {
        _favoriteMovies = movies;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching movie details: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF141414),

      appBar: AppBar(

        title: const Text('Phim yêu thích'),
        backgroundColor: Color(0xFF141414),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : _favoriteMovies.isEmpty
          ? const Center(child: Text('No favorite movies found.'))
          : ListView.builder(
        itemCount: _favoriteMovies.length,
        itemBuilder: (context, index) {
          final movie = _favoriteMovies[index];
          return Card(
            color: const Color(0xFF1E1E1E),
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (movie.poster.isNotEmpty)
                        Container(
                          width: 100,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(
                                  '${dotenv.env['API']}${movie.poster}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Đạo diễn: ${movie.director}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              'Thời lượng: ${movie.duration} phút',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              'Giới hạn độ tuổi: ${movie.limitAge}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: movie.categories.map((category) {
                                return Chip(
                                  label: Text(
                                    category['categoryName'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor:
                                  const Color(0xFF141414),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}

