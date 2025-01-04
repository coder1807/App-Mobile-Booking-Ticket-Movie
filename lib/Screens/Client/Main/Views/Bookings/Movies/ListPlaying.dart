import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/Api/movie/movie.dart';
import 'package:movie_app/Themes/app_theme.dart';

class ListPlayingPage extends StatefulWidget {
  const ListPlayingPage({super.key});

  @override
  State<ListPlayingPage> createState() => _ListPlayingPageState();
}

class _ListPlayingPageState extends State<ListPlayingPage> {
  late Future<List<Map<String, dynamic>>> movies;

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
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 25,
              color: AppTheme.colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: AppTheme.colors.mainBackground),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Wrap(
                children: [_PlayingMovieItem(),]
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _PlayingMovieItem() {
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
        final moviesData = snapshot.data ?? [];

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: moviesData.map((movie) {
            return SizedBox(
              width: (MediaQuery.of(context).size.width - 30) / 2, // Mỗi item chiếm nửa chiều rộng màn hình
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      '${dotenv.env['API']}' + movie['poster']!,
                      width: double.infinity,
                      height: 280,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 30) / 2,
                    child: Text(
                      movie['name']!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: AppTheme.colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: AppTheme.colors.buttonColor,
                      ),
                      onPressed: () {},
                      child: Text(
                        'Book Now',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: AppTheme.colors.mainBackground,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
