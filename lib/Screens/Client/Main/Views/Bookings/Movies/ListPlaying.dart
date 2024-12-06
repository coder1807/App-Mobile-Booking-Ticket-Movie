import 'package:flutter/material.dart';
import 'package:movie_app/Themes/app_theme.dart';

class ListPlayingPage extends StatefulWidget {
  const ListPlayingPage({super.key});

  @override
  State<ListPlayingPage> createState() => _ListPlayingPageState();
}

class _ListPlayingPageState extends State<ListPlayingPage> {
  final List<Map<String, String>> PlayingMovies = [
    {
      'title': 'DEADPOOL 3',
      'image': 'assets/images/Poster/Playing/Deadpool.jpg'
    },
    {
      'title': 'BLUE BEETLE',
      'image': 'assets/images/Poster/Playing/Bluebeetle.jpg'
    },
    {
      'title': 'THE FLASH',
      'image': 'assets/images/Poster/Playing/Theflash.jpg'
    },
    {
      'title': "FIVE NIGHT AT FREDDY's",
      'image': 'assets/images/Poster/Playing/Fivenightatfreddy.jpg'
    },
  ];

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
                children: PlayingMovies.map((movie) => _PlayingMovieItem(movie))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _PlayingMovieItem(Map<String, String> movie) {
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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: AppTheme.colors.buttonColor),
            onPressed: () {},
            child: Text(
              'Book Now',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: AppTheme.colors.mainBackground),
            ),
          ),
        ],
      ),
    );
  }
}
