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
  String selectedTab = 'All';
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
          'Cinema',
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
                hintText: 'Search cinema',
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
                    selectedTab = 'All';
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    gradient: selectedTab == 'All'
                        ? LinearGradient(
                            colors: [Colors.pink, Colors.purple],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: selectedTab == 'All' ? null : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      'All',
                      style: TextStyle(
                        color:
                            selectedTab == 'All' ? Colors.white : Colors.grey,
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
                    selectedTab = 'Favorites';
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  padding: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    gradient: selectedTab == 'Favorites'
                        ? LinearGradient(
                            colors: [Colors.purple, Colors.pink],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color:
                        selectedTab == 'Favorites' ? null : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      'Favorites',
                      style: TextStyle(
                        color: selectedTab == 'Favorites'
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
            (selectedTab == 'All' ||
                (selectedTab == 'Favorites' && cinema.isFavorite)) &&
            cinema.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Column(
      children: filteredCinemas.map((cinema) {
        return _buildCinemaItem(cinema);
      }).toList(),
    );
  }

  /*Widget _buildCinemaItem(CinemaItem cinema) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cinema.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    cinema.location,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }*/
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
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      cinema.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: cinema.isFavorite ? Colors.pink : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        cinema.isFavorite = !cinema.isFavorite;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    cinema.name,
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
/*
class _CinemaPageState extends State<CinemaPage> {
  String selectedTab = 'All';
  String searchQuery = '';

  List<CinemaItem> cinemas = [
    CinemaItem(
      // imageUrl: 'assets/images/Theater/cinema1.jpg',
      name: 'Cinema 99 Premiere',
      // rating: 4.9,
      // reviewCount: '10.4k reviews',
      // distance: '3.1 km',
      location: 'Jakarta',
      isFavorite: false, id: 1,
    ),
    CinemaItem(
      // imageUrl: 'assets/images/Theater/cinema2.jpg',
      name: 'Black Prime Future',
      // rating: 5.0,
      // reviewCount: '20.1k reviews',
      // distance: '6.7 km',
      location: 'Jakarta',
      isFavorite: true, id: 2,
    ),
    CinemaItem(
      // imageUrl: 'assets/images/Theater/cinema3.jpg',
      name: 'Cinema 99 Premiere',
      // rating: 4.9,
      // reviewCount: '10.4k reviews',
      // distance: '3.1 km',
      location: 'Jakarta',
      isFavorite: false, id: 3,
    ),
    CinemaItem(
      // imageUrl: 'assets/images/Theater/cinema4.jpg',
      name: 'Cinema 99 Premiere',
      // rating: 4.9,
      // reviewCount: '10.4k reviews',
      // distance: '3.1 km',
      location: 'Jakarta',

      isFavorite: true, id: 4,
    ),
  ];

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
          'Cinema',
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
                hintText: 'Search cinema',
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
                    selectedTab = 'All';
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    gradient: selectedTab == 'All'
                        ? LinearGradient(
                            colors: [Colors.pink, Colors.purple],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: selectedTab == 'All' ? null : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      'All',
                      style: TextStyle(
                        color:
                            selectedTab == 'All' ? Colors.white : Colors.grey,
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
                    selectedTab = 'Favorites';
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  padding: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    gradient: selectedTab == 'Favorites'
                        ? LinearGradient(
                            colors: [Colors.purple, Colors.pink],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color:
                        selectedTab == 'Favorites' ? null : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      'Favorites',
                      style: TextStyle(
                        color: selectedTab == 'Favorites'
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
    final filteredCinemas = cinemas
        .where((cinema) =>
            (selectedTab == 'All' ||
                (selectedTab == 'Favorites' && cinema.isFavorite)) &&
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
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              // child: Image.asset(
              //   cinema.imageUrl,
              //   width: 80,
              //   height: 80,
              //   fit: BoxFit.cover,
              // ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cinema.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Row(
                    // children: List.generate(
                    //   5,
                    //   (index) => Icon(
                    //     Icons.star,
                    //     color: index < cinema.rating.toInt()
                    //         ? Colors.orange
                    //         : Colors.grey,
                    //     size: 16,
                    //   ),
                    // ),
                  ),
                  Row(
                    // children: [
                    //   Text(
                    //     '${cinema.rating} ',
                    //     style: TextStyle(fontWeight: FontWeight.bold),
                    //   ),
                    //   Text('(${cinema.reviewCount})',
                    //       style: TextStyle(color: Colors.grey)),
                    // ],
                  ),
                  Row(
                    // children: [
                    //   Icon(Icons.location_on, color: Colors.pink, size: 16),
                    //   SizedBox(width: 4),
                    //   Text(
                    //     '${cinema.distance} (${cinema.location})',
                    //     style: TextStyle(color: Colors.grey),
                    //   ),
                    // ],
                  ),
                ],
              ),
            ),
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
          ],
        ),
      ),
    );
  }
}*/


