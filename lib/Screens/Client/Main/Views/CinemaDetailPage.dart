import 'package:flutter/material.dart';
import 'package:movie_app/Api/movie/movie.dart';
import 'package:movie_app/Screens/Client/Main/Model/CinemaItem.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/Screens/Client/Main/Model/MovieItem.dart';
import 'package:movie_app/Screens/Client/Main/Model/ScheduleItem.dart';
import 'package:movie_app/Screens/Client/Main/Views/Bookings/Movies/SeatBooking.dart';
import 'package:movie_app/models/movie.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_url_extractor/google_maps_url_extractor.dart';


class CinemaDetailPage extends StatefulWidget {
  final int cinemaId;
  final Movie? selectedMovie;

  const CinemaDetailPage(
      {super.key, required this.cinemaId, this.selectedMovie});

  @override
  _CinemaDetailPageState createState() => _CinemaDetailPageState();
}

class _CinemaDetailPageState extends State<CinemaDetailPage> {
  CinemaItem? cinema;
  bool isLoading = true;
  List<ScheduleItem> schedules = [];
  List<MovieItem> films = [];
  List<Category> categories = [];
  GoogleMapController? mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _fetchCinemaDetails();
    print("Selected Movie in CinemaDetailPage: ${widget.selectedMovie?.name}");
    if (widget.selectedMovie == null) {
      print("No movie selected.");
    }
    loadSchedulesAndMovies();
  }

  Future<void> _fetchCinemaDetails() async {
    try {
      final detail = await fetchCinemaDetail(widget.cinemaId);
      setState(() {
        cinema = detail;
        isLoading = false;
        _initializeMap();
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching cinema details: $e');
    }
  }

  Future<CinemaItem> fetchCinemaDetail(int cinemaId) async {
    final baseUrl = dotenv.env['MY_URL'];
    if (baseUrl == null) {
      throw Exception('Base URL is null. Please check the .env file.');
    }
    final response = await http.get(Uri.parse('$baseUrl/cinema/$cinemaId'));
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.isNotEmpty) {
        return CinemaItem.fromJson(responseBody[0]);
      } else {
        throw Exception('No cinema data found');
      }
    } else {
      throw Exception(
          'Failed to load cinema details. Status code: ${response.statusCode}');
    }
  }

  Future<List<MovieItem>> fetchFilmsByFilmId(int filmId) async {
    final baseUrl = dotenv.env['MY_URL'];
    if (baseUrl == null) {
      throw Exception('Base URL is null. Please check the .env file.');
    }

    try {
      if (filmId <= 0) {
        print('Invalid filmId: $filmId');
        return [];
      }

      final response = await http.get(Uri.parse('$baseUrl/movie/$filmId'));
      print("Movie Response body for filmId $filmId: ${response.body}");

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          print('Empty response for filmId $filmId');
          return [];
        }

        final dynamic decodedData = json.decode(response.body);
        if (decodedData == null) {
          print('Null response data for filmId $filmId');
          return [];
        }

        if (decodedData is List) {
          return decodedData
              .where((item) => item != null)
              .map((json) => MovieItem.fromJson(json))
              .toList();
        } else if (decodedData is Map<String, dynamic>) {
          return [MovieItem.fromJson(decodedData)];
        }

        print('Unexpected response format for filmId $filmId');
        return [];
      } else {
        print(
            'Failed to load film $filmId. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error in fetchFilmsByFilmId for filmId $filmId: $e');
      return [];
    }
  }

  Map<int, List<ScheduleItem>> groupSchedulesByFilmId(
      List<ScheduleItem> schedules) {
    var map = <int, List<ScheduleItem>>{};
    for (var schedule in schedules) {
      if (schedule.filmId != null && schedule.filmId! > 0) {
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
      final response =
      await http.get(Uri.parse('$baseUrl/schedules/$cinemaId'));
      print("Schedules Response body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ScheduleItem.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load schedules. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchSchedulesByCinemaId: $e');
      return [];
    }
  }

  Future<void> loadSchedulesAndMovies() async {
    try {
      late List<ScheduleItem> details;
      print(widget.selectedMovie);
      if (widget.selectedMovie != null) {
        details = await fetchSchedulesByMovieAndCinema(
            widget.cinemaId, widget.selectedMovie!.id);
      } else {
        details = await fetchSchedules(widget.cinemaId);
      }
      final groupedSchedules = groupSchedulesByFilmId(details);
      print('Grouped Schedules by FilmId: $groupedSchedules');

      final List<int> listFilmId = groupedSchedules.keys.toList();
      print('Valid filmIds: $listFilmId');

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
  }
  // Hàm di chuyển camera tới vị trí cụ thể
  void _centerMapOnLocation(LatLng position) {
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: position,
            zoom: 15,
          ),
        ),
      );
    }
  }
  void _addOrUpdateMarker(LatLng position) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('cinema'),
          position: position,
          infoWindow: InfoWindow(
            title: cinema?.name ?? '',
            snippet: cinema?.location ?? '',
          ),
        ),
      );
    });
  }
  // Hàm trả về LatLng mặc định
  LatLng _getDefaultLatLng() {
    return const LatLng(10.7623, 106.6814);
  }
  Future<LatLng?> _extractCoordinatesFromGoogleMapsUrl(String googleMapsUrl) async {
    try {
      final data = await GoogleMapsUrlExtractor.processGoogleMapsUrl(googleMapsUrl);
      if (data != null && data['latitude'] != null && data['longitude'] != null) {
        return LatLng(data['latitude']!, data['longitude']!);
      }
      print("Could not extract coordinates from Google Maps URL: $googleMapsUrl");
      return null;
    } catch (e) {
      print("Error extracting coordinates from Google Maps URL: $e");
      return null;
    }
  }

  Future<void> _initializeMap() async {
    print('Initializing map with data: ${cinema?.map}');
    if (cinema != null && cinema!.map.isNotEmpty) {
      final googleMapsUrl = cinema!.map;
      final latLng = await _extractCoordinatesFromGoogleMapsUrl(googleMapsUrl);

      if (latLng != null) {
        _addOrUpdateMarker(latLng);
        _centerMapOnLocation(latLng);
      } else {
        print("Could not extract coordinates from URL, falling back to default");
        _addOrUpdateMarker(_getDefaultLatLng());
        _centerMapOnLocation(_getDefaultLatLng());
      }
    } else {
      print('Cinema or map data is null/empty');
      _addOrUpdateMarker(_getDefaultLatLng());
      _centerMapOnLocation(_getDefaultLatLng());
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
                style: const TextStyle(
                    fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white24),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GoogleMap(
                    onMapCreated: (controller) {
                      mapController = controller;
                      print('Map controller created');
                    },
                    initialCameraPosition: CameraPosition(
                      target: _getDefaultLatLng(),
                      zoom: 15,
                    ),
                    markers: _markers,
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: true,
                    zoomGesturesEnabled: true,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: schedules.isEmpty
                    ? const Text('Không có lịch chiếu',
                    style: TextStyle(color: Colors.white))
                    : ListView.builder(
                  itemCount:
                  groupSchedulesByFilmId(schedules).length,
                  itemBuilder: (context, index) {
                    final groupedSchedules =
                    groupSchedulesByFilmId(schedules);
                    final filmId =
                    groupedSchedules.keys.elementAt(index);
                    final filmSchedules =
                    groupedSchedules[filmId]!;

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
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                if (movie.poster.isNotEmpty)
                                  Container(
                                    width: 100,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(
                                          8),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            '${dotenv.env['API']}${movie.poster}'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        movie.name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight:
                                          FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Đạo diễn: ${movie.director}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color:
                                            Colors.white70),
                                      ),
                                      Text(
                                        'Thời lượng: ${movie.duration} phút',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color:
                                            Colors.white70),
                                      ),
                                      Text(
                                        'Giới hạn độ tuổi: ${movie.limit_age}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color:
                                            Colors.white70),
                                      ),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: movie
                                            .categories
                                            .map((category) {
                                          return Chip(
                                            label: Text(
                                              category
                                                  .categoryName,
                                              style: TextStyle(
                                                  color: Colors
                                                      .white),
                                            ),
                                            backgroundColor:
                                            Color(
                                                0xFF141414),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
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
                              children:
                              filmSchedules.map((schedule) {
                                final time = _formatDateTime(
                                    schedule.start);
                                return ElevatedButton(
                                  style:
                                  ElevatedButton.styleFrom(
                                    backgroundColor:
                                    Color(0xFF2C2C2C),
                                    foregroundColor:
                                    Colors.white,
                                    padding:
                                    EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SeatBooking(
                                              schedule: schedule,
                                              roomId:
                                              schedule.roomId,
                                              movie: movie,
                                            ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    time,
                                    style:
                                    TextStyle(fontSize: 16),
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