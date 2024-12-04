import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/Themes/app_theme.dart';
import 'package:video_player/video_player.dart';

class DetailMovieComingPage extends StatefulWidget {
  const DetailMovieComingPage({super.key});

  @override
  State<DetailMovieComingPage> createState() => _DetailMovieComingPageState();
}

class _DetailMovieComingPageState extends State<DetailMovieComingPage> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isPlaying = true;
  bool _isWatchlisted = false;

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  void _initialisePlayer() {
    _videoPlayerController = VideoPlayerController.asset(
      "assets/videos/Deadpool_1.mp4",
    );
    _videoPlayerController!.initialize().then((_) {
      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController!,
          autoPlay: false,
          looping: false,
        );
        _isPlaying = true;
      });
    }).catchError((error) {});
  }

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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _isWatchlisted = !_isWatchlisted;
                      });
                    },
                    icon: Icon(
                      _isWatchlisted ? Icons.favorite : Icons.favorite_border,
                      color: _isWatchlisted ? Colors.red : Colors.white,
                    ),
                    label: Text(
                      'Watchlist',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _isWatchlisted ? Colors.red : Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      side: BorderSide(
                          color: _isWatchlisted ? Colors.red : Colors.white,
                          width: 1),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                  ),
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
              const SizedBox(
                height: 10,
              ),
              Center(
                child: _chewieController != null && _isPlaying
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        child: Chewie(controller: _chewieController!),
                      )
                    : ElevatedButton(
                        onPressed: _initialisePlayer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.colors.buttonColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Play video',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: AppTheme.colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
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
