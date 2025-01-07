import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/Api/movie/movie.dart';
import 'package:movie_app/Screens/Client/Main/Views/Bookings/Movies/CinemaBooking.dart';
import 'package:movie_app/Themes/app_theme.dart';
import 'package:movie_app/manager/UserProvider.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/models/user.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailMoviePage extends StatefulWidget {
  final Movie movie;
  const DetailMoviePage({super.key, required this.movie});

  @override
  State<DetailMoviePage> createState() => _DetailMoviePageState();
}

class _DetailMoviePageState extends State<DetailMoviePage> {
  late YoutubePlayerController _youtubePlayerController;
  bool _isPlayerReady = false;
  List<Map<String, dynamic>> _ratings = [];
  double _averageRating = 0.0;
  bool _isLoading = true;
  late User user;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _fetchRatings();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      user = Provider.of<UserProvider>(context, listen: false).user!;
      await checkFavoriteStatus();
    });
    // Khởi tạo controller cho YouTube Player với video ID
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: widget.movie.trailer, // Mã trailer YouTube
      flags: YoutubePlayerFlags(
        autoPlay: false, // Không tự động phát khi mở
        mute: false, // Không tắt âm
      ),
    );
    _isPlayerReady = true;
  }

  @override
  void dispose() {
    if (_isPlayerReady) {
      _youtubePlayerController
          .dispose(); // Giải phóng tài nguyên khi không sử dụng nữa
    }
    super.dispose();
  }

  Future<void> _fetchRatings() async {
    final ratings =
        await fetchRatingByMovies(widget.movie.id); // Gọi hàm API với ID phim.
    if (ratings.isNotEmpty) {
      // Tính điểm trung bình.
      double average =
          ratings.fold(0.0, (sum, item) => sum + item['ratingNumber']) /
              ratings.length;
      setState(() {
        _ratings = ratings;
        _averageRating = average;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> checkFavoriteStatus() async {
    try {
      final baseUrl = dotenv.env['MY_URL'];
      final response = await http.get(
        Uri.parse('$baseUrl/user/${user.id}/favorites'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> favoriteIds = json.decode(response.body);
        setState(() {
          isFavorite = favoriteIds.contains(widget.movie.id);
        });
      }
    } catch (e) {
      print('Error checking favorite status: $e');
    }
  }

  Future<void> toggleFavorite() async {
    try {
      final baseUrl = dotenv.env['MY_URL'];
      final Uri uri = Uri.parse(
        '$baseUrl/user/${user.id}/favorites/${widget.movie.id}',
      );

      final response = isFavorite
          ? await http
              .delete(uri, headers: {'Content-Type': 'application/json'})
          : await http.post(
              uri,
              headers: {'Content-Type': 'application/json'},
            );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Check if response body is not empty
        if (response.body.isNotEmpty) {
          try {
            final Map<String, dynamic> responseData =
                json.decode(response.body);
            if (responseData != null) {
              final updatedUser = User.fromJson(responseData);
              Provider.of<UserProvider>(context, listen: false)
                  .updateUserInfoDynamic(updatedUser.toJson());
            }
          } catch (e) {
            print('Error parsing user data: $e');
          }
        }

        setState(() {
          isFavorite = !isFavorite;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isFavorite ? 'Đã thêm vào Yêu Thích' : 'Đã xóa khỏi Yêu Thích',
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: isFavorite ? Colors.green : Colors.red,
          ),
        );
      } else {
        print(
            'API Error: Status Code ${response.statusCode}, ${response.body}');
        throw Exception('Failed to update favorites: ${response.statusCode}');
      }
    } catch (e) {
      print('Error on toggleFavorite: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error updating favorites. Please try again.',
            style: const TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).user!;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Movie Title',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.colors.white),
          ),
          backgroundColor: AppTheme.colors.mainBackground,
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                size: 20,
                color: AppTheme.colors.white,
              )),
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(color: AppTheme.colors.mainBackground),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          '${dotenv.env['API']}${widget.movie.poster}',
                          height: 250,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.movie.name,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.colors.white,
                                  fontFamily: 'Poppins'),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Duration: ${widget.movie.duration} minutes',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  color: AppTheme.colors.white),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Director: ${widget.movie.director}',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  color: AppTheme.colors.white),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  'AR:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    color: AppTheme.colors.white,
                                  ),
                                ),
                                const SizedBox(width: 40),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.red, width: 1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    widget.movie.limitAge,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Genres: ${widget.movie.categories.map((e) => e['categoryName']).join(', ')}',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  color: AppTheme.colors.white),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isFavorite
                            ? Colors.red
                            : AppTheme.colors
                                .white, // Border color changes based on favorite state
                        width: 1.5, // Border width
                      ),
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6), // Remove any extra padding
                        backgroundColor:
                            Colors.transparent, // Transparent background
                        alignment: Alignment
                            .centerLeft, // Align icon and text to the left
                      ),
                      onPressed: toggleFavorite,
                      child: Row(
                        children: [
                          Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color:
                                isFavorite ? Colors.red : AppTheme.colors.white,
                            size: 28,
                          ),
                          SizedBox(width: 8), // Space between icon and text
                          Text(
                            isFavorite
                                ? 'Đã thêm vào Yêu Thích'
                                : 'Thêm vào Yêu Thích',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.colors.white, // Adjust text color
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Watch Trailer',
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        color: AppTheme.colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  YoutubePlayerBuilder(
                      player: YoutubePlayer(
                        controller: _youtubePlayerController,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.amber,
                        onReady: () {
                          print("Player is ready.");
                        },
                      ),
                      builder: (context, player) {
                        return Column(
                          children: [
                            // some widgets
                            player,
                            //some other widgets
                          ],
                        );
                      }),
                  const SizedBox(height: 20),
                  Text(
                    'Synopsis',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.movie.description,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.colors.white),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Cast',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.colors.white),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        6,
                        (index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(
                                  'assets/images/Casts/Deadpool_${index + 1}.jpg'),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Photos',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: AppTheme.colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(
                        6,
                        (index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/images/Movies/Deadpool_${index + 1}.jpg',
                                width: 200,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Rating',
                    style: TextStyle(
                        color: AppTheme.colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins'),
                  ),
                  const SizedBox(height: 10),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (_ratings.isEmpty)
                    Center(
                      child: Text(
                        'No rating yet',
                        style: TextStyle(
                          color: AppTheme.colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    )
                  else
                    Center(
                      child: Column(
                        children: [
                          Text(
                            _averageRating.toStringAsFixed(1),
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: AppTheme.colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 30,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              5,
                              (index) => Icon(
                                Icons.star,
                                size: 25,
                                color: index < _averageRating.round()
                                    ? Colors.amber
                                    : Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '(${_ratings.length} Reviews)',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: AppTheme.colors.white,
                            ),
                          ),
                          const SizedBox(
                              height: 20), // Hiển thị danh sách đánh giá
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _ratings.length,
                            itemBuilder: (context, index) {
                              final rating = _ratings[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppTheme.colors.darkBlue,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start, // Căn lề trái cho toàn bộ Column
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                rating['fullName'],
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: AppTheme.colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: List.generate(
                                                  5,
                                                  (starIndex) => Icon(
                                                    Icons.star,
                                                    size: 20,
                                                    color: starIndex <
                                                            rating[
                                                                'ratingNumber']
                                                        ? Colors.amber
                                                        : Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            rating['ratingContent'],
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 13,
                                              color: AppTheme.colors.white,
                                            ),
                                          ),
                                        ])),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                        onPressed: () {
                          _showRatingDialog();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.colors.buttonColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: Text(
                          'Rate this Movie',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppTheme.colors.white),
                        )),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CinemaBookingPage(movie: widget.movie)));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.colors.buttonColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: Text(
                        'Book Now',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  void _showRatingDialog() {
    final TextEditingController _contentController = TextEditingController();
    int _selectedRating = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.colors.mainBackground,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(
            'Rate this Movie',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.colors.white,
            ),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            _selectedRating = index + 1;
                          });
                        },
                        icon: Icon(
                          Icons.star,
                          color: index < _selectedRating
                              ? Colors.amber
                              : Colors.grey,
                          size: 30,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _contentController,
                    maxLines: 3,
                    style: TextStyle(color: AppTheme.colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter your review...',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: AppTheme.colors.darkBlue,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.grey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final ratingDTO = {
                  'filmId': widget.movie.id,
                  'userId': user.id, // Đặt ID người dùng hiện tại.
                  'content': _contentController.text,
                  'ratingNumber': _selectedRating,
                };

                final result = await submitRating(ratingDTO);
                if (result) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Thank you for your review!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  _fetchRatings();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to submit your review.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.colors.buttonColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                'Submit',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
