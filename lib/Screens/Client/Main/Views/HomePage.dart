import 'package:flutter/material.dart';
import 'package:movie_app/Screens/Client/Main/Views/Bookings/Movies/CinemaBooking.dart';
import 'package:movie_app/Screens/Client/Main/Views/Bookings/Movies/DetailMovie.dart';
import 'package:movie_app/Screens/Client/Main/Views/Bookings/Movies/DetailMovieComing.dart';
import 'package:movie_app/Themes/app_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> movies = [
    {
      'name': 'Movie 1',
      'poster': 'assets/images/Poster/Playing/image_1.jpg',
      'genres': ['Action', 'Drama'],
    },
    {
      'name': 'Movie 2',
      'poster': 'assets/images/Poster/Playing/image_2.jpg',
      'genres': ['Comedy', 'Romance'],
    },
    {
      'name': 'Movie 3',
      'poster': 'assets/images/Poster/Playing/image_3.jpg',
      'genres': ['Horror'],
    },
    {
      'name': 'Movie 4',
      'poster': 'assets/images/Poster/Playing/image_4.jpg',
      'genres': ['Sci-Fi', 'Adventure'],
    },
  ];
  Map<int, bool> bookmarkedMovies = {};

  @override
  void initState() {
    super.initState();
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
                  'Hey, Leonor! ',
                  style: TextStyle(
                      color: AppTheme.colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins'),
                ),
                Text(
                  'Good morning!',
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
                  'Recommendation',
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
            _MovieUpcoming(),
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: movies.map((movie) {
          return Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DetailMoviePage(),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      movie['poster'],
                      width: 150,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DetailMoviePage(),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 100,
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
                const SizedBox(height: 4),
                Text(
                  movie['genres'].join(', '),
                  style:
                      TextStyle(fontSize: 12, color: AppTheme.colors.greyColor),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CinemaBookingPage(),
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
  }

  // ignore: non_constant_identifier_names
  Widget _MovieUpcoming() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: movies.map((movie) {
          int movieIndex = movies.indexOf(movie);
          bool isBookmarked = bookmarkedMovies[movieIndex] ?? false;

          return Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const DetailMovieComingPage(),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            movie['poster'],
                            width: 150,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        )),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            bookmarkedMovies[movieIndex] = !isBookmarked;
                          });
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AppTheme.colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: isBookmarked
                                ? AppTheme.colors.pink
                                : AppTheme.colors.black, // Màu icon
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DetailMovieComingPage(),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 100,
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
                const SizedBox(height: 4),
                Text(
                  movie['genres'].join(', '),
                  style:
                      TextStyle(fontSize: 12, color: AppTheme.colors.greyColor),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
