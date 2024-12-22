import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/Themes/app_theme.dart';
import 'package:movie_app/models/movie.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailMoviePage extends StatefulWidget {
  final Movie movie;
  const DetailMoviePage({super.key, required this.movie});

  @override
  State<DetailMoviePage> createState() => _DetailMoviePageState();
}

class _DetailMoviePageState extends State<DetailMoviePage> {
  late YoutubePlayerController _youtubePlayerController;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();

    // Khởi tạo controller cho YouTube Player với video ID
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: widget.movie.trailer, // Mã trailer YouTube
      flags: YoutubePlayerFlags(
        autoPlay: false, // Không tự động phát khi mở
        mute: false, // Không tắt âm
      ),
    );
    _isPlayerReady = true;
  }

  @override
  void dispose() {
    if (_isPlayerReady) {
      _youtubePlayerController
          .dispose(); // Giải phóng tài nguyên khi không sử dụng nữa
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Movie Title',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.colors.white),
          ),
          backgroundColor: AppTheme.colors.mainBackground,
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                size: 20,
                color: AppTheme.colors.white,
              )),
        ),
        body: Stack(
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
                        child: Image.network(
                          '${dotenv.env['API']}${widget.movie.poster}',
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
                              widget.movie.name,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.colors.white,
                                  fontFamily: 'Poppins'),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Duration: ${widget.movie.duration} minutes',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  color: AppTheme.colors.white),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Director: ${widget.movie.director}',
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
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    widget.movie.limitAge,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Genres: ${widget.movie.categories.map((e) => e['categoryName']).join(', ')}',
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
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        color: AppTheme.colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  YoutubePlayerBuilder(
                      player: YoutubePlayer(
                        controller: _youtubePlayerController,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.amber,
                        onReady: () {
                          print("Player is ready.");
                        },
                      ),
                      builder: (context, player) {
                        return Column(
                          children: [
                            // some widgets
                            player,
                            //some other widgets
                          ],
                        );
                      }),
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
                    widget.movie.description,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.colors.white),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Cast',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.colors.white),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        6,
                        (index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(
                                  'assets/images/Casts/Deadpool_${index + 1}.jpg'),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Photos',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: AppTheme.colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(
                        6,
                        (index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/images/Movies/Deadpool_${index + 1}.jpg',
                                width: 200,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Rating',
                    style: TextStyle(
                        color: AppTheme.colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins'),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          '4.5',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: AppTheme.colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 30),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            5,
                            (index) {
                              return const Icon(
                                Icons.star,
                                size: 25,
                                color: Colors.amber,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "(100 Reviews)",
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: AppTheme.colors.white),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.colors.buttonColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: Text(
                          'Rate this Movie',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppTheme.colors.white),
                        )),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.colors.buttonColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: Text(
                        'Book Now',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
