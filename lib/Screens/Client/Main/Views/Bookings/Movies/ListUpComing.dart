import 'package:flutter/material.dart';
import 'package:movie_app/Themes/app_theme.dart';

class ListUpComingPage extends StatefulWidget {
  const ListUpComingPage({super.key});

  @override
  State<ListUpComingPage> createState() => _ListUpComingPageState();
}

class _ListUpComingPageState extends State<ListUpComingPage> {
  final List<Map<String, String>> upComingMovies = [
    {
      'title': 'AQUAMAN',
      'image': 'assets/images/Poster/Coming/Aquaman.jpg',
    },
    {
      'title': 'EXPEND4BLES',
      'image': 'assets/images/Poster/Coming/Expend4bles.jpg',
    },
    {
      'title': 'KRAVEN',
      'image': 'assets/images/Poster/Coming/Kraven.jpg',
    },
    {
      'title': 'THE MARVELS',
      'image': 'assets/images/Poster/Coming/Themarvels.jpg',
    }
  ];
  final Map<String, bool> favoriteStatus = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.colors.mainBackground,
        title: Text(
          'Now Playing',
          style: TextStyle(
              fontFamily: 'Poppins',
              color: AppTheme.colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: Icon(
          Icons.arrow_back,
          size: 25,
          color: AppTheme.colors.white,
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: AppTheme.colors.mainBackground),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: upComingMovies
                    .map((movie) => _UpComingMovieItem(movie))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _UpComingMovieItem(Map<String, String> movie) {
    bool isLiked = favoriteStatus[movie['title']] ?? false;

    return SizedBox(
      width: (MediaQuery.of(context).size.width - 30) / 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              movie['image']!,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: (MediaQuery.of(context).size.width - 30) / 2,
            child: Text(
              movie['title']!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: AppTheme.colors.white,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                favoriteStatus[movie['title']!] = !isLiked;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: isLiked
                    ? AppTheme.colors.buttonColor.withOpacity(0.1)
                    : Colors.transparent,
                border: Border.all(
                  color: isLiked ? Colors.red : AppTheme.colors.greyColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.favorite,
                    color: isLiked ? Colors.red : AppTheme.colors.greyColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Watchlist',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: AppTheme.colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
