import 'package:flutter/material.dart';
import 'package:movie_app/Screens/Client/Main/Model/CinemaItem.dart';
import 'package:movie_app/Screens/Client/Main/Views/CinemaDetailPage.dart';
import 'package:movie_app/Themes/app_theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CinemaPage extends StatefulWidget {
  const CinemaPage({super.key});

  @override
  State<CinemaPage> createState() => _CinemaPageState();
}

class _CinemaPageState extends State<CinemaPage> {
  String selectedTab = 'Tất cả';
  String searchQuery = '';
  List<CinemaItem> cinemas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCinemas();
  }

  Future<void> fetchCinemas() async {
    try {
      final baseUrl = dotenv.env['MY_URL']; // Đọc MY_URL từ .env
      final response = await http
          .get(Uri.parse('$baseUrl/cinemas')); // Thêm /cinemas vào cuối URL
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          cinemas = data.map((json) => CinemaItem.fromJson(json)).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching cinemas: $e');
      setState(() {
        isLoading = false;
      });
    }
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
          'Các rạp chiếu hiện có',
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
                hintText: 'Tìm kiếm rạp phim',
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
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTab = 'Tất cả';
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    gradient: selectedTab == 'Tất cả'
                        ? LinearGradient(
                            colors: [Colors.pink, Colors.purple],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: selectedTab == 'Tất cả' ? null : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      'Tất cả',
                      style: TextStyle(
                        color:
                            selectedTab == 'Tất cả' ? Colors.white : Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTab = 'Yêu thích';
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  padding: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    gradient: selectedTab == 'Yêu thích'
                        ? LinearGradient(
                            colors: [Colors.purple, Colors.pink],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color:
                        selectedTab == 'Yêu thích' ? null : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      'Yêu thích',
                      style: TextStyle(
                        color: selectedTab == 'Yêu thích'
                            ? Colors.white
                            : Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
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
            (selectedTab == 'Tất cả' ||
                (selectedTab == 'Yêu thích' && cinema.isFavorite)) &&
            cinema.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Column(
      children: filteredCinemas.map((cinema) {
        return _buildCinemaItem(cinema);
      }).toList(),
    );
  }

  Widget _buildCinemaItem(CinemaItem cinema) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CinemaDetailPage(
                cinemaId: cinema.id,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        cinema.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: cinema.isFavorite ? Colors.pink : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          cinema.isFavorite = !cinema.isFavorite;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        cinema.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
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



