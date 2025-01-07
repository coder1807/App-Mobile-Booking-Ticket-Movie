import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/Api/movie/movie.dart';
import 'package:movie_app/Screens/Client/Main/Views/Bookings/Movies/CinemaBooking.dart';
import 'package:movie_app/Screens/Client/Main/Views/Bookings/Movies/DetailMovie.dart';
import 'package:movie_app/Themes/app_theme.dart';
import 'package:movie_app/models/movie.dart';

class ListPlayingPage extends StatefulWidget {
  const ListPlayingPage({super.key});

  @override
  State<ListPlayingPage> createState() => _ListPlayingPageState();
}

class _ListPlayingPageState extends State<ListPlayingPage> {
  late Future<List<Map<String, dynamic>>> movies;
  late Future<List<Map<String, dynamic>>>
      categories; // Danh sách thể loại từ API
  String _searchQuery = '';
  String? _selectedGenre; // Giá trị mặc định là null để hiển thị "All"

  @override
  void initState() {
    super.initState();
    categories = fetchCategories(); // Lấy danh sách thể loại từ API
  }

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
            fontWeight: FontWeight.w600,
          ),
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
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: AppTheme.colors.mainBackground),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                _buildFilterAndSearchBar(), // Thanh tìm kiếm và bộ lọc
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: [_PlayingMovieItem()],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterAndSearchBar() {
    return Row(
      children: [
        // Tìm kiếm theo tên
        Expanded(
          flex: 3,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: AppTheme.colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              style: TextStyle(
                color: AppTheme.colors.white,
                fontFamily: 'Poppins',
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppTheme.colors.white.withOpacity(0.1),
                hintText: 'Tên phim...',
                hintStyle: TextStyle(
                  color: AppTheme.colors.white.withOpacity(0.6),
                  fontFamily: 'Poppins',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search, color: AppTheme.colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Lọc theo thể loại
        Expanded(
          flex: 2,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: AppTheme.colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: categories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Text(
                    'Error loading categories',
                    style: TextStyle(color: AppTheme.colors.white),
                  );
                }

                final categoryList = [
                  {'id': null, 'name': 'Tất cả'}, // Thêm tùy chọn "All"
                  ...snapshot.data!
                ];

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: DropdownButton<String?>(
                    value: _selectedGenre ?? 'Tất cả',
                    dropdownColor: AppTheme.colors.mainBackground,
                    icon: Icon(Icons.arrow_drop_down,
                        color: AppTheme.colors.white),
                    isExpanded: true,
                    underline: Container(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGenre = value == 'Tất cả' ? null : value;
                      });
                    },
                    items: categoryList.map((genre) {
                      return DropdownMenuItem<String?>(
                        value: genre['name'],
                        child: Text(
                          genre['name'],
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: AppTheme.colors.white,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _PlayingMovieItem() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchMovies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final moviesData = snapshot.data ?? [];

        // Áp dụng bộ lọc và tìm kiếm
        final filteredMovies = moviesData.where((movie) {
          final movieName = removeDiacritics(movie['name']!.toLowerCase());
          final searchQuery = removeDiacritics(_searchQuery.toLowerCase());
          final matchesSearchQuery =
              searchQuery.isEmpty || movieName.contains(searchQuery);
          final matchesGenre =
              _selectedGenre == null || // Nếu "All" thì không lọc
                  movie['categories'].any(
                      (category) => category['categoryName'] == _selectedGenre);
          return matchesSearchQuery && matchesGenre;
        }).toList();
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: filteredMovies.map((movie) {
            return SizedBox(
              width: (MediaQuery.of(context).size.width - 30) / 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      final selectedMovie = Movie.fromJson(movie);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailMoviePage(
                            movie: selectedMovie,
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        '${dotenv.env['API']}' + movie['poster']!,
                        width: double.infinity,
                        height: 280,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      final selectedMovie = Movie.fromJson(movie);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailMoviePage(
                            movie: selectedMovie,
                          ),
                        ),
                      );
                    },
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

  String removeDiacritics(String str) {
    final withDiacritics =
        'àáảãạăằắẳẵặâầấẩẫậèéẻẽẹêềếểễệìíỉĩịòóỏõọôồốổỗộơờớởỡợùúủũụưừứửữựỳýỷỹỵđ'
        'ÀÁẢÃẠĂẰẮẲẴẶÂẦẤẨẪẬÈÉẺẼẸÊỀẾỂỄỆÌÍỈĨỊÒÓỎÕỌÔỒỐỔỖỘƠỜỚỞỠỢÙÚỦŨỤƯỪỨỬỮỰỲÝỶỸỴĐ';
    final withoutDiacritics =
        'aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyd'
        'AAAAAAAAAAAAAAAAAEEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOOOUUUUUUUUUUUYYYYYD';

    for (int i = 0; i < withDiacritics.length; i++) {
      str = str.replaceAll(withDiacritics[i], withoutDiacritics[i]);
    }
    return str;
  }
}
