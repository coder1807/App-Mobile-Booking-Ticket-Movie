import 'package:flutter/material.dart';
import 'package:movie_app/Api/movie/movie.dart';
import 'package:movie_app/Screens/Client/Main/Model/CinemaItem.dart';
import 'package:movie_app/Screens/Client/Main/Views/CinemaDetailPage.dart';
import 'package:movie_app/Themes/app_theme.dart';
import 'package:movie_app/models/movie.dart';

class CinemaBookingPage extends StatefulWidget {
  final Movie movie;
  const CinemaBookingPage({Key? key, required this.movie}) : super(key: key);

  @override
  State<CinemaBookingPage> createState() => _CinemaBookingPageState();
}

class _CinemaBookingPageState extends State<CinemaBookingPage> {
  String searchQuery = '';
  List<Map<String, dynamic>> cinemas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCinema();
  }

  Future<void> _fetchCinema() async {
    final response = await fetchCinemasByMovie(widget.movie.id);
    setState(() {
      cinemas = response;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.mainBackground,
      body: _page(),
      appBar: AppBar(
        title: Text('Đặt Vé Phim ${widget.movie.name}'),
        foregroundColor: AppTheme.colors.white,
        backgroundColor:
            AppTheme.colors.mainBackground, // Thêm màu sắc cho AppBar
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, // Nút quay lại
            color: AppTheme.colors.white, // Màu của nút
          ),
          onPressed: () {
            Navigator.pop(context); // Quay lại trang trước
          },
        ),
      ),
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
                _mainPage(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _headerPage() {
    return Column(
      children: [
        Text(
          'Chọn Rạp',
          style: TextStyle(
            color: AppTheme.colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Stack(
          alignment: Alignment.centerRight,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Tìm Kiếm Rạp',
                hintStyle:
                    TextStyle(color: AppTheme.colors.white.withOpacity(0.5)),
                filled: true,
                fillColor: AppTheme.colors.black.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
              ),
              style: TextStyle(color: AppTheme.colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Icon(
                Icons.search,
                color: AppTheme.colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _mainPage() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    final filteredCinemas = cinemas
        .where((cinema) =>
            cinema['name'].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return ListView.builder(
      shrinkWrap: true,
      itemCount: filteredCinemas.length,
      itemBuilder: (context, index) {
        return _buildCinemaItem(filteredCinemas[index]);
      },
    );
  }

  Widget _buildCinemaItem(Map<String, dynamic> cinema) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CinemaDetailPage(
                cinemaId: cinema['id'],
                selectedMovie: widget.movie,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(width: 8),
                  Text(
                    cinema['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
