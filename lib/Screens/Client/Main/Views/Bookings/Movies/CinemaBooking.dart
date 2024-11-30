import 'package:flutter/material.dart';
import 'package:movie_app/Themes/app_theme.dart';

class CinemaBookingPage extends StatefulWidget {
  const CinemaBookingPage({super.key});

  @override
  State<CinemaBookingPage> createState() => _CinemaBookingPageState();
}

class _CinemaBookingPageState extends State<CinemaBookingPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppTheme.colors.mainBackground,
            title: Text(
              'Cinemas',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.colors.white),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {},
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(100),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: TextField(
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter your location',
                        hintStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                        filled: true,
                        fillColor: Colors.white10,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const TabBar(
                    indicatorColor: Colors.red,
                    labelColor: Colors.red,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(text: 'All Cinema'),
                      Tab(text: 'Favorites'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: Container(
            color: AppTheme.colors.mainBackground,
            child: TabBarView(
              children: [
                _cinemaList(),
                _cinemaList(favoritesOnly: true),
              ],
            ),
          )),
    );
  }

  Widget _cinemaList({bool favoritesOnly = false}) {
    final cinemas = [
      {'name': 'AMC Empire 25', 'isFavorite': true},
      {'name': 'Regal E-Walk 4DX & RPX', 'isFavorite': false},
      {'name': 'Angelika Film Center', 'isFavorite': true},
      {'name': 'Nitehawk Cinema', 'isFavorite': false},
      {'name': 'Alamo Drafthouse', 'isFavorite': false},
      {'name': 'IFC Center', 'isFavorite': false},
      {'name': 'Metrograph', 'isFavorite': false},
    ];

    final filteredCinemas = favoritesOnly
        ? cinemas.where((cinema) => cinema['isFavorite'] as bool).toList()
        : cinemas;

    return ListView.separated(
      itemCount: filteredCinemas.length,
      itemBuilder: (context, index) {
        final cinema = filteredCinemas[index];
        return ListTile(
          leading: Icon(
            cinema['isFavorite'] as bool ? Icons.star : Icons.star_border,
            color: cinema['isFavorite'] as bool ? Colors.amber : Colors.grey,
          ),
          title: Text(
            cinema['name'] as String,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
          onTap: () {},
        );
      },
      separatorBuilder: (context, index) => const Divider(
        color: Colors.grey,
        thickness: 0.5,
        indent: 16,
        endIndent: 16,
      ),
    );
  }
}
