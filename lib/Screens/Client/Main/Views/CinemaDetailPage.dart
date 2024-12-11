import 'package:flutter/material.dart';
import 'package:movie_app/Screens/Client/Main/Model/CinemaItem.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/Screens/Client/Main/Model/MovieItem.dart';
import 'package:movie_app/Screens/Client/Main/Model/ScheduleItem.dart';

class CinemaDetailPage extends StatefulWidget {
  final int cinemaId;

  const CinemaDetailPage({super.key, required this.cinemaId});

  @override
  _CinemaDetailPageState createState() => _CinemaDetailPageState();
}

class _CinemaDetailPageState extends State<CinemaDetailPage> {
  CinemaItem? cinema; // Nullable CinemaItem
  bool isLoading = true; // Loading state for UI
  List<ScheduleItem> schedules = []; // List of schedules
  List<MovieItem> films = [];
  List<Category> categories =[];

  @override
  void initState() {
    super.initState();
    _fetchCinemaDetails();
    loadSchedulesAndMovies();
  }

  // Fetch cinema details using the provided cinemaId
  Future<void> _fetchCinemaDetails() async {
    try {
      final detail = await fetchCinemaDetail(widget.cinemaId);
      setState(() {
        cinema = detail;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching cinema details: $e');
    }
  }
  // Fetch cinema details from the API
  Future<CinemaItem> fetchCinemaDetail(int cinemaId) async {
    final baseUrl = dotenv.env['MY_URL'];
    if (baseUrl == null) {
      throw Exception('Base URL is null. Please check the .env file.');
    }

    final response = await http.get(Uri.parse('$baseUrl/cinema/$cinemaId'));

    // Debugging response body
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      // Parse the response body as a list and take the first item
      final List<dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.isNotEmpty) {
        return CinemaItem.fromJson(responseBody[0]);
      } else {
        throw Exception('No cinema data found');
      }
    } else {
      throw Exception('Failed to load cinema details. Status code: ${response.statusCode}');
    }
  }
  //fetch all schedules associated with the chosen cinema
  Future<List<MovieItem>> fetchFilmsByFilmId(int filmId) async {
    final baseUrl = dotenv.env['MY_URL'];
    if (baseUrl == null) {
      throw Exception('Base URL is null. Please check the .env file.');
    }

    try {
      // Check if filmId is valid
      if (filmId <= 0) {
        throw Exception('Invalid filmId: $filmId');
      }

      final response = await http.get(Uri.parse('$baseUrl/movie?id=$filmId'));
      print("Movie Response body for filmId $filmId: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Check if data is null or empty
        if (data.isEmpty) {
          print('No movie data found for filmId $filmId');
          return [];
        }

        return data.map((json) => MovieItem.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load film $filmId. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchFilmsByFilmId for filmId $filmId: $e');
      return []; // Return empty list instead of throwing exception
    }
  }

  Map<int, List<ScheduleItem>> groupSchedulesByFilmId(List<ScheduleItem> schedules) {
    var map = <int, List<ScheduleItem>>{};
    for (var schedule in schedules) {
      if (schedule.filmId != null && schedule.filmId! > 0) { // Check for null or invalid filmId
        if (!map.containsKey(schedule.filmId!)) {
          map[schedule.filmId!] = [];
        }
        map[schedule.filmId!]!.add(schedule);
      }
    }
    return map;
  }

  Future<List<ScheduleItem>> fetchSchedules(int cinemaId) async {
    final baseUrl = dotenv.env['MY_URL'];
    if (baseUrl == null) {
      throw Exception('Base URL is null. Please check the .env file.');
    }
    try {
      final response = await http.get(Uri.parse('$baseUrl/schedules/$cinemaId'));
      print("Schedules Response body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ScheduleItem.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load schedules. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchSchedulesByCinemaId: $e');
      return []; // Trả về list rỗng thay vì throw exception
    }
  }

  Future<void> loadSchedulesAndMovies() async {
    try {
      // Debug: Print the grouped schedules by filmId
      try {
        final details = await fetchSchedules(widget.cinemaId);
        final groupedSchedules = groupSchedulesByFilmId(details);
        print('Grouped Schedules by FilmId: $groupedSchedules');

        final List<int> listFilmId = groupedSchedules.keys.toList();
        print('Valid filmIds: $listFilmId');

        // Fetch movie details for each valid filmId
        List<MovieItem> fetchedMovies = [];
        for (var filmId in listFilmId) {
          final movies = await fetchFilmsByFilmId(filmId);
          if (movies.isNotEmpty) {
            print('Fetched movie details for filmId $filmId: ${movies[0].name}');
            fetchedMovies.add(movies[0]);
          } else {
            print('No movie found for filmId $filmId');
          }
        }
        setState(() {
          schedules = details;
          films = fetchedMovies;
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print('Error fetching schedules: $e');
      }
    } catch (e) {
      print('Error in loadSchedulesAndMovies: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF141414),
      appBar: AppBar(
        title: Text(cinema?.name ?? ''),
        backgroundColor: Color(0xFF141414),
        foregroundColor: Colors.white,
      ),
      body: Container(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : cinema == null
            ? const Center(child: Text('Failed to load cinema details'))
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Địa chỉ: ${cinema!.location}',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 20),
              // const Text(
              //   'Lịch chiếu:',
              //   style: TextStyle(
              //     fontSize: 20,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.white,
              //   ),
              // ),
              const SizedBox(height: 10),
              Expanded(
                child: schedules.isEmpty
                    ? const Text('Không có lịch chiếu', style: TextStyle(color: Colors.white))
                    : ListView.builder(
                  itemCount: groupSchedulesByFilmId(schedules).length,
                  itemBuilder: (context, index) {
                    final groupedSchedules = groupSchedulesByFilmId(schedules);
                    final filmId = groupedSchedules.keys.elementAt(index);
                    final filmSchedules = groupedSchedules[filmId]!;

                    // Tìm thông tin movie tương ứng
                    final movie = films.firstWhere(
                          (m) => m.id == filmId,
                      orElse: () => MovieItem(
                        id: filmId,
                        name: 'Unknown',
                        poster: '',
                        categories: categories,
                        openingday: '',
                        quanlity: '',
                        subtitle: '',
                        trailer: '',
                        description: '',
                        director: '',
                        duration: 0,
                        limit_age: 'NaN',
                        actor: '',
                        countryName: '',
                      ),
                    );

                    return Card(
                      color: Color(0xFF1E1E1E),
                      margin: EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Movie info section
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Movie poster
                                if (movie.poster.isNotEmpty)
                                  Container(
                                    width: 100,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          '${dotenv.env['API']}'+movie.poster
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                SizedBox(width: 12),
                                // Movie details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        movie.name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Đạo diễn: ${movie.director}',
                                        style: TextStyle(fontSize: 14, color: Colors.white70),
                                      ),
                                      Text(
                                        'Thời lượng: ${movie.duration} phút',
                                        style: TextStyle(fontSize: 14, color: Colors.white70),
                                      ),
                                      Text(
                                        'Giới hạn độ tuổi: ${movie.limit_age}',
                                        style: TextStyle(fontSize: 14, color: Colors.white70),
                                      ),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: movie.categories.map((category) {
                                          return Chip(
                                            label: Text(
                                              category.categoryName,
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            backgroundColor: Color(0xFF141414),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            // Showtimes section
                            Text(
                              'Giờ chiếu:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 8),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: filmSchedules.map((schedule) {
                                final time = _formatDateTime(schedule.start);
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF2C2C2C),
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  ),
                                  onPressed: () {
                                    // Xử lý khi chọn giờ chiếu
                                    print('Selected time: ${schedule.start}');
                                  },
                                  child: Text(
                                    time,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Chưa có lịch';
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
