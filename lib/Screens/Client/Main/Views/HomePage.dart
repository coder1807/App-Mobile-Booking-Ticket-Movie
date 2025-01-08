import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/Api/movie/movie.dart';
import 'package:movie_app/Screens/Client/Main/Views/Bookings/Movies/CinemaBooking.dart';
import 'package:movie_app/Screens/Client/Main/Views/Bookings/Movies/DetailMovie.dart';
import 'package:movie_app/Screens/Client/Main/Views/Bookings/Movies/ListPlaying.dart';
import 'package:movie_app/Themes/app_theme.dart';
import 'package:movie_app/manager/UserProvider.dart';
import 'package:movie_app/models/movie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _user_fullname;

  late Future<List<Map<String, dynamic>>> movies;
  Map<int, bool> bookmarkedMovies = {};

  Future<void> _loadInfoUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _user_fullname = prefs.getString('user_fullname') ?? 'Chào mừng';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadInfoUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.mainBackground,
      body: _page(),
    );
  }

  Widget _page() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            child: Column(
              children: [
                _headerPage(),
                const SizedBox(height: 30),
                _mainPage()
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _headerPage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/images/User/avatar.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$_user_fullname',
                  style: TextStyle(
                      color: AppTheme.colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins'),
                ),
                Text(
                  'Xin chào!',
                  style:
                      TextStyle(fontSize: 14, color: AppTheme.colors.greyColor),
                ),
              ],
            ),
          ],
        ),
        Icon(
          Icons.notifications,
          size: 30,
          color: AppTheme.colors.greyColor,
        ),
      ],
    );
  }

  Widget _mainPage() {
    return Stack(
      children: [
        Column(
          children: [
            _buildPromotionBanner(),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // const SizedBox(width: 10),
                Text(
                  'Now Playing',
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: AppTheme.colors.white),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ListPlayingPage()));
                    },
                    child: Row(
                      children: [
                        Text(
                          'View ALL',
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: AppTheme.colors.orange),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: AppTheme.colors.orange,
                          size: 15,
                        )
                      ],
                    ))
              ],
            ),
            const SizedBox(height: 10),
            _MovieRecommendation(),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // const SizedBox(width: 10),
                Text(
                  'Upcoming',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: AppTheme.colors.white),
                ),
                Text(
                  'View all',
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: AppTheme.colors.white),
                )
              ],
            ),
            const SizedBox(height: 10),
            // _MovieUpcoming(),
          ],
        )
      ],
    );
  }

  Widget _buildPromotionBanner() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          'assets/images/Poster/poster2.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _MovieRecommendation() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchMovies(), // Lấy danh sách phim từ API
      builder: (context, snapshot) {
        // Nếu đang đợi dữ liệu
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        // Nếu có lỗi khi tải dữ liệu
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // Dữ liệu phim đã được tải về
        final moviesData = snapshot.data?.take(4) ?? [];

        // Hiển thị các phim nếu có dữ liệu
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: moviesData.map((movie) {
              return Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        final selectedMovie = Movie.fromJson(movie);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailMoviePage(movie: selectedMovie),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          '${dotenv.env['API']}' +
                              movie['poster'], // Lấy poster từ API (ipv4 local)
                          width: 150,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    GestureDetector(
                      onTap: () {
                        final selectedMovie = Movie.fromJson(movie);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailMoviePage(movie: selectedMovie),
                          ),
                        );
                      },
                      child: SizedBox(
                        width: 160,
                        child: Text(
                          movie['name'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.colors.white,
                            fontFamily: 'Poppins',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        final selectedMovie = Movie.fromJson(movie);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CinemaBookingPage(
                              movie: selectedMovie,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.colors.pink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Book",
                        style: TextStyle(color: AppTheme.colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // ignore: non_constant_identifier_names
  // Widget _MovieUpcoming() {
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Row(
  //       children: movies.map((movie) {
  //         int movieIndex = movies.indexOf(movie);
  //         bool isBookmarked = bookmarkedMovies[movieIndex] ?? false;
  //
  //         return Padding(
  //           padding: const EdgeInsets.all(5),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Stack(
  //                 children: [
  //                   ElevatedButton(
  //                       onPressed: () {
  //                         Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                             builder: (context) =>
  //                                 const DetailMovieComingPage(),
  //                           ),
  //                         );
  //                       },
  //                       child: ClipRRect(
  //                         borderRadius: BorderRadius.circular(15),
  //                         child: Image.asset(
  //                           movie['poster'],
  //                           width: 150,
  //                           height: 200,
  //                           fit: BoxFit.cover,
  //                         ),
  //                       )),
  //                   Positioned(
  //                     top: 10,
  //                     right: 10,
  //                     child: GestureDetector(
  //                       onTap: () {
  //                         setState(() {
  //                           bookmarkedMovies[movieIndex] = !isBookmarked;
  //                         });
  //                       },
  //                       child: Container(
  //                         width: 30,
  //                         height: 30,
  //                         decoration: BoxDecoration(
  //                           color: AppTheme.colors.white,
  //                           shape: BoxShape.circle,
  //                         ),
  //                         child: Icon(
  //                           isBookmarked
  //                               ? Icons.bookmark
  //                               : Icons.bookmark_border,
  //                           color: isBookmarked
  //                               ? AppTheme.colors.pink
  //                               : AppTheme.colors.black, // Màu icon
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 8),
  //               const SizedBox(height: 20),
  //               GestureDetector(
  //                 onTap: () {
  //                   Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder: (context) => const DetailMovieComingPage(),
  //                     ),
  //                   );
  //                 },
  //                 child: SizedBox(
  //                   width: 100,
  //                   child: Text(
  //                     movie['name'],
  //                     maxLines: 1,
  //                     overflow: TextOverflow.ellipsis,
  //                     style: TextStyle(
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.bold,
  //                       color: AppTheme.colors.white,
  //                       fontFamily: 'Poppins',
  //                     ),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(height: 4),
  //               Text(
  //                 movie['genres'].join(', '),
  //                 style:
  //                     TextStyle(fontSize: 12, color: AppTheme.colors.greyColor),
  //               ),
  //               const SizedBox(height: 8),
  //             ],
  //           ),
  //         );
  //       }).toList(),
  //     ),
  //   );
  // }
}
