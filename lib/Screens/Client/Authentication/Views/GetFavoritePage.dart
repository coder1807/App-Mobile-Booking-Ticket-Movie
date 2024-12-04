import 'package:flutter/material.dart';
import 'package:movie_app/Screens/Client/Authentication/Views/DecoratePage.dart';
import 'package:movie_app/Screens/Client/Authentication/Views/SignInPage.dart';
import 'package:movie_app/Screens/Components/CustomButton.dart';

class GetFavoritePage extends StatefulWidget {
  const GetFavoritePage({super.key});

  @override
  State<GetFavoritePage> createState() => _GetFavoritePageState();
}

class _GetFavoritePageState extends State<GetFavoritePage> {
  List<String> selectedGenres = [];

  void toggleGenreSelection(String genre) {
    setState(() {
      if (selectedGenres.contains(genre)) {
        selectedGenres.remove(genre);
      } else {
        selectedGenres.add(genre);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121011),
      body: _page(),
    );
  }

  Widget _page() {
    final List<String> genres = [
      "Action",
      "Adventure",
      "Drama",
      "Comedy",
      "Crime",
      "Documentary",
      "Sports",
      "Fantasy",
      "Horror",
      "Music",
      "Western",
      "Thriller",
      "Sci-fi"
    ];

    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DecoratePage()),
                      );
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Color(0xffD4D4D4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 150),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    alignment: WrapAlignment.center,
                    children: genres.map((genre) {
                      bool isSelected = selectedGenres.contains(genre);
                      return GestureDetector(
                        onTap: () => toggleGenreSelection(genre),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.red : Colors.grey[800],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            genre,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 200),
                const Center(
                  child: SizedBox(
                    width: 250,
                    child: Text(
                      'Select thr genres you like to watch ',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                CustomButton(
                  text: 'Next',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInPage()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE50914),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
