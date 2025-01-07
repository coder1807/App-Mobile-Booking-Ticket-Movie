import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/Screens/Client/Main/Model/MovieItem.dart';
import 'package:movie_app/Themes/app_theme.dart';
import 'package:movie_app/models/movie.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BookingDetailsPage extends StatefulWidget {
  final dynamic ticket;

  const BookingDetailsPage({Key? key, required this.ticket}) : super(key: key);

  @override
  _BookingDetailsPageState createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  MovieItem? movieDetails;
  num price = 0;
  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
  }

  String getShowTime(Map<String, dynamic> ticket) {
    DateTime startTime = DateTime.parse(ticket['startTime']);
    DateTime createAt = DateTime.parse(ticket['createAt']);
    DateTime startDate = DateTime(createAt.year, createAt.month, createAt.day,
        startTime.hour, startTime.minute);

    // So sánh giờ và phút của startTime với createAt
    if (startTime.isBefore(createAt)) {
      // Nếu giờ và phút của startTime nhỏ hơn createAt thì thay đổi ngày
      startDate = DateTime(createAt.year, createAt.month, createAt.day + 1,
          startTime.hour, startTime.minute);
    }

    // Trả về lịch chiếu đã được format
    return formatDate(startDate.toIso8601String());
  }

  Future<void> fetchMovieDetails() async {
    final filmName = Uri.encodeComponent(widget.ticket['filmName']);
    final url = '${dotenv.env['MY_URL']}/movie?name=$filmName';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          movieDetails = MovieItem.fromJson(data.isNotEmpty ? data[0] : null);
        });
      } else {
        throw Exception('Failed to fetch movie details');
      }
    } catch (e) {
      print('Error fetching movie details: $e');
    }
  }

  String formatDate(String dateTime) {
    final parsedDate = DateTime.parse(dateTime);
    return DateFormat('dd/MM/yyyy - HH:mm').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    final ticket = widget.ticket;
    final seatDetails = calculateSeatDetails(ticket['seatName']);
    final comboFoodPrice =
        ticket['comboFood'] != null ? ticket['comboFood']['price'] : 0;
    price = seatDetails['totalPrice'] + comboFoodPrice;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Chi tiết vé',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: movieDetails == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            '${dotenv.env['API']}' + movieDetails!.poster,
                            width: 170,
                            height: 250,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movieDetails!.name,
                                style: TextStyle(
                                    color: AppTheme.colors.white,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Thời lượng : ${movieDetails!.duration} minutes',
                                style: TextStyle(
                                    color: AppTheme.colors.white,
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Đạo diễn : ${movieDetails!.director}',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    color: AppTheme.colors.white,
                                    fontSize: 14),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    'Độ tuổi',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: AppTheme.colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
                                  ),
                                  const SizedBox(width: 40),
                                  Text(
                                    ":",
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: AppTheme.colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 7),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: AppTheme.colors.buttonColor,
                                          width: 1),
                                    ),
                                    child: Text(
                                      'C${movieDetails!.limit_age}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Thể loại: ${movieDetails!.categories.map((e) => e.categoryName).join(', ')}',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    color: AppTheme.colors.white),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Booking Details
                    const SectionTitle(title: 'Chi tiết vé'),
                    DetailRow(label: 'Rạp phim', value: ticket['cinemaName']),
                    DetailRow(label: 'Ghế đã đặt', value: ticket['seatName']),
                    DetailRow(
                      label: 'Suất chiếu',
                      value: getShowTime(ticket),
                    ),
                    DetailRow(
                        label: 'Ngày đặt',
                        value: formatDate(ticket['createAt'])),
                    DetailRow(
                      label: 'Phương thức thanh toán',
                      value: ticket['payment'].isEmpty
                          ? 'Trực tiếp tại rạp'
                          : ticket['payment'],
                    ),
                    const SectionTitle(title: 'Chi tiết giá'),
                    if (ticket['comboFood'] != null)
                      DetailRow(
                          label: 'Combo food đã đặt',
                          value: ticket['comboFood']['price']),
                    ..._buildPriceDetails(ticket['seatName']),
                    DetailRow(
                      label: 'Tổng tiền',
                      value: '${price.toStringAsFixed(0)} VNĐ',
                      isBold: true,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  List<Widget> _buildPriceDetails(String seatString) {
    final seatDetails = calculateSeatDetails(seatString);
    List<Widget> priceDetails = [];

    // Nếu có ghế lẻ, hiển thị
    if (seatDetails['singleSeats'].isNotEmpty) {
      priceDetails.add(
        DetailRow(
          label: 'Ghế đơn (${seatDetails['singleSeats'].length})',
          value:
              '${seatDetails['singleSeats'].join(', ')} - ${seatDetails['singleTotalPrice'].toStringAsFixed(0)} VNĐ',
        ),
      );
    }

    // Nếu có ghế đôi, hiển thị
    if (seatDetails['coupleSeats'].isNotEmpty) {
      priceDetails.add(
        DetailRow(
          label: 'Ghế đôi (${seatDetails['coupleSeats'].length})',
          value:
              '${seatDetails['coupleSeats'].join(', ')} - ${seatDetails['coupleTotalPrice'].toStringAsFixed(0)} VNĐ',
        ),
      );
    }
    // Luôn hiển thị tổng giá
    priceDetails.add(
      DetailRow(
        label: 'Tiền ghế',
        value: '${seatDetails['totalPrice'].toStringAsFixed(0)} VNĐ',
      ),
    );

    return priceDetails;
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color valueColor;

  const DetailRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

Map<String, dynamic> calculateSeatDetails(String seatString) {
  // Tách các ghế từ chuỗi, loại bỏ khoảng trắng thừa
  final seats = seatString.split(',').map((seat) => seat.trim()).toList();

  // Khởi tạo danh sách và tổng tiền cho từng loại ghế
  final List<String> singleSeats = [];
  final List<String> coupleSeats = [];
  double singleTotalPrice = 0;
  double coupleTotalPrice = 0;

  // Phân loại ghế và tính giá
  for (final seat in seats) {
    if (seat.startsWith('G')) {
      coupleSeats.add(seat);
      coupleTotalPrice += 120000;
    } else {
      singleSeats.add(seat);
      singleTotalPrice += 80000;
    }
  }

  // Trả về chi tiết
  return {
    'singleSeats': singleSeats,
    'coupleSeats': coupleSeats,
    'singleTotalPrice': singleTotalPrice,
    'coupleTotalPrice': coupleTotalPrice,
    'totalPrice': singleTotalPrice + coupleTotalPrice, // Tổng tiền
  };
}
