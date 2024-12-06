import 'package:flutter/material.dart';
import 'package:movie_app/Themes/app_theme.dart';

class DetailMovieComingPage extends StatefulWidget {
  const DetailMovieComingPage({super.key});

  @override
  State<DetailMovieComingPage> createState() => _DetailMovieComingPageState();
}

class _DetailMovieComingPageState extends State<DetailMovieComingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.colors.mainBackground,
        title: Text(
          'Movie Title',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: AppTheme.colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            size: 20,
            color: AppTheme.colors.white,
          ),
        ),
      ),
      body: _page(),
    );
  }

  Widget _page() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(color: AppTheme.colors.mainBackground),
        ),
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/Poster/poster1.jpg',
                      height: 250,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DEADPOOL 3',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.colors.white,
                              fontFamily: 'Poppins'),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Duration: 128 minutes',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              color: AppTheme.colors.white),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Director: John Doe',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              color: AppTheme.colors.white),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'AR:',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                color: AppTheme.colors.white,
                              ),
                            ),
                            const SizedBox(width: 40),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.red, width: 1),
                                  borderRadius: BorderRadius.circular(4)),
                              child: const Text(
                                'PG-13',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    color: Colors.red,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Genres: Action, Adventure',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              color: AppTheme.colors.white),
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Watch Trailer',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                'Synopsis',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                'This is the synopsis of the movie. It provides a brief overview of the',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
