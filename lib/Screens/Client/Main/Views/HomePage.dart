import 'package:flutter/material.dart';
import 'package:movie_app/Themes/app_theme.dart';
import 'package:movie_app/Screens/Client/Main/Views/Bookings/SeatBooking.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> movies = [
    {
      'name': 'Movie 1',
      'poster': 'assets/images/image_1.jpg',
      'genres': ['Action', 'Drama'],
    },
    {
      'name': 'Movie 2',
      'poster': 'assets/images/image_2.jpg',
      'genres': ['Comedy', 'Romance'],
    },
    {
      'name': 'Movie 3',
      'poster': 'assets/images/image_3.jpg',
      'genres': ['Horror'],
    },
    {
      'name': 'Movie 4',
      'poster': 'assets/images/image_4.jpg',
      'genres': ['Sci-Fi', 'Adventure'],
    },
  ];

  // Tạo một Map để lưu trạng thái bookmark cho từng bộ phim
  Map<int, bool> bookmarkedMovies = {};

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121011),
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
            // Avatar hình tròn
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/images/User/avatar.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hey, Leomord! ',
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
        // Icon thông báo
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
                  'Recomendation',
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
                  'Upcomming',
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    movie['poster'],
                    width: 150,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 8),
                const SizedBox(height: 20),
                Container(
                  width: 100,
                  child: Text(
                    movie['name'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.colors.white,
                        overflow: TextOverflow.ellipsis,
                        fontFamily: 'Poppins'),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  movie['genres'].join(', '),
                  style:
                      TextStyle(fontSize: 12, color: AppTheme.colors.greyColor),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SeatBooking(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink, // Màu nền của nút
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Book",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        movie['poster'],
                        width: 150,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
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
                SizedBox(height: 8),
                const SizedBox(height: 20),
                Container(
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
                SizedBox(height: 4),
                Text(
                  movie['genres'].join(', '),
                  style:
                      TextStyle(fontSize: 12, color: AppTheme.colors.greyColor),
                ),
                SizedBox(height: 8),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
