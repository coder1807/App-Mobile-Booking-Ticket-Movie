import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/Api/Food/foods.dart';
import 'package:movie_app/Api/movie/movie.dart';
import 'package:movie_app/Screens/Client/Main/Model/BookingItem.dart';
import 'package:movie_app/Screens/Client/Main/Model/CinemaItem.dart';
import 'package:movie_app/Screens/Client/Main/Model/MovieItem.dart';
import 'package:movie_app/Screens/Client/Main/Model/ScheduleItem.dart';
import 'package:movie_app/Themes/app_theme.dart';
import 'package:movie_app/models/movie.dart';

class BookingSummaryMovie extends StatefulWidget {
  final BookingItem bookingItem;
  final MovieItem movie;
  final ScheduleItem scheduleItem;
  final Map<String, String> seatTypeMap; // Nhận map loại ghế
  const BookingSummaryMovie(
      {Key? key,
      required this.bookingItem,
      required this.movie,
      required this.scheduleItem,
      required this.seatTypeMap})
      : super(key: key);
  @override
  State<BookingSummaryMovie> createState() => _BookingSummaryMovieState();
}

class _BookingSummaryMovieState extends State<BookingSummaryMovie> {
  late String cinema = "";
  late List<String> singleSeats = List.empty();
  late List<String> coupleSeats = List.empty();
  late double singleTotalPrice;
  late double coupleTotalPrice;
  late double previousComboFoodPrice = 0.0;
  late double comboFoodPrice = 0.0; // Thêm biến này để lưu giá combo food
  late DateTime displayDate;
  String? selectComboFood = '';
  List<Map<String, dynamic>> foodCombos = [];
  @override
  void initState() {
    _fetchCinemaName();
    _buildSeatSummary();
    fetchFoods().then((data) {
      setState(() {
        foodCombos = data;
        foodCombos
            .insert(0, {'id': 0, 'name': 'Không chọn combo food', 'price': 0});
        if (foodCombos.isNotEmpty) {
          selectComboFood = foodCombos.first['name'];
        }
      });
    });
    final scheduleDate = widget.scheduleItem.start ?? DateTime.now();
    displayDate = scheduleDate.isAfter(DateTime.now())
        ? scheduleDate
        : DateTime.now().add(Duration(days: 1));

    // TODO: implement initState
    super.initState();
  }

  void _buildSeatSummary() {
    final seatDetails = _calculateSeatDetails();
    singleSeats = seatDetails['singleSeats'] as List<String>;
    coupleSeats = seatDetails['coupleSeats'] as List<String>;
    singleTotalPrice = (seatDetails['singleTotalPrice'] as num).toDouble();
    coupleTotalPrice = (seatDetails['coupleTotalPrice'] as num).toDouble();
  }

  void _fetchCinemaName() async {
    final response =
        await fetchCinemaBySchedule(widget.scheduleItem.scheduleId);
    cinema = response[0]['name'];
  }

  void _updateComboFood(String? comboName) {
    final combo =
        foodCombos.firstWhere((element) => element['name'] == comboName);
    setState(() {
      comboFoodPrice = combo['price'].toDouble();
      widget.bookingItem.totalPrice += comboFoodPrice - previousComboFoodPrice;
      widget.bookingItem.foodID = combo['id']; // Cập nhật foodId
      previousComboFoodPrice = comboFoodPrice;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.colors.mainBackground,
        title: Text(
          'Review Summary',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppTheme.colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _page(screenWidth),
    );
  }

  Widget _page(double screenWidth) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(color: AppTheme.colors.mainBackground),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          '${dotenv.env['API']}' + widget.movie.poster,
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
                              widget.movie.name,
                              style: TextStyle(
                                  color: AppTheme.colors.white,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Duration : ${widget.movie.duration} minutes',
                              style: TextStyle(
                                  color: AppTheme.colors.white,
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Director : ${widget.movie.director}',
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
                                  'AR',
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
                                    'C${widget.movie.limit_age}',
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
                              'Genres: ${widget.movie.categories.map((e) => e.categoryName).join(', ')}',
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
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: AppTheme.colors.containerBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Book Details',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.colors.white,
                          ),
                        ),
                        const Divider(color: Colors.grey),
                        Column(
                          children: [
                            _detailRow('Cinema', cinema),
                            _detailRow('Seat(s)',
                                widget.bookingItem.seatSymbols.join(', ')),
                            _detailRow(
                              'Date',
                              DateFormat('dd/MM/yyyy').format(displayDate),
                            ),
                            _detailRow(
                              'Hour',
                              DateFormat('HH:mm').format(
                                  widget.scheduleItem.start ?? displayDate),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: AppTheme.colors.containerBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price Details',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.colors.white,
                          ),
                        ),
                        Divider(color: AppTheme.colors.greyColor),
                        Column(
                          children: [
                            _detailRow(
                              'Single   (${singleSeats.length}): ${singleSeats.join(', ')}',
                              singleTotalPrice.toStringAsFixed(0) + ' VNĐ',
                            ),
                            _detailRow(
                              'Couple (${coupleSeats.length}): ${coupleSeats.join(', ')}',
                              coupleTotalPrice.toStringAsFixed(0) + ' VNĐ',
                            ),
                            _detailRow(
                                '${selectComboFood ?? 'Không chọn combo food'}:',
                                comboFoodPrice.toStringAsFixed(0) + ' VNĐ'),
                          ],
                        ),
                        Divider(
                          color: AppTheme.colors.greyColor,
                        ),
                        _detailRow('Actual Pay',
                            '${widget.bookingItem.totalPrice.toStringAsFixed(0)} VNĐ')
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Select Combo Food',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.colors.containerBackground,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        dropdownColor: AppTheme.colors.containerBackground,
                        value: selectComboFood,
                        hint: Text(
                          'Choose a combo',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.grey,
                          ),
                        ),
                        icon: Icon(Icons.arrow_drop_down,
                            color: AppTheme.colors.white),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: AppTheme.colors.white,
                        ),
                        underline: SizedBox(),
                        items: foodCombos.map<DropdownMenuItem<String>>(
                            (Map<String, dynamic> combo) {
                          return DropdownMenuItem<String>(
                            value: combo['name'],
                            child: Text(
                                '${combo['name']} ${combo['price'] > 0 ? ' - ' + combo['price'].toString() + ' VND' : ''}'),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectComboFood = newValue;
                            _updateComboFood(newValue);
                          });
                        },
                      )),
                  const SizedBox(height: 20),
                  Text(
                    'Promo & Vouchers',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter the promo code or voucher',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: AppTheme.colors.containerBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: screenWidth,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.colors.buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // Navigate to payment
                      },
                      child: Text(
                        'Continue to Payment',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: AppTheme.colors.greyColor,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: AppTheme.colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _calculateSeatDetails() {
    final singleSeats = widget.bookingItem.seatSymbols
        .where((seat) => widget.seatTypeMap[seat] == 'single')
        .toList();

    final coupleSeats = widget.bookingItem.seatSymbols
        .where((seat) => widget.seatTypeMap[seat] == 'couple')
        .toList();

    final singleSeatPrice = 80000;
    final coupleSeatPrice = 120000;

    final singleTotalPrice = singleSeats.length * singleSeatPrice;
    final coupleTotalPrice = coupleSeats.length * coupleSeatPrice;

    return {
      'singleSeats': singleSeats,
      'coupleSeats': coupleSeats,
      'singleTotalPrice': singleTotalPrice,
      'coupleTotalPrice': coupleTotalPrice,
    };
  }
}
