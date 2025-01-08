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
import 'package:url_launcher/url_launcher.dart';
import 'package:movie_app/manager/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

Future<void> _launchUrl(String url) async {
  final Uri _url = Uri.parse(url);
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}

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
  String? selectedPromo;
  double originPrice = 0;
  double promoDiscount = 0.0;
  List<Map<String, dynamic>> foodCombos = [];
  List<Map<String, dynamic>> promoOptions = [];
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
    originPrice = widget.bookingItem.totalPrice;
    _buildPromoOptions("NONE");
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
      widget.bookingItem.totalPrice = originPrice + comboFoodPrice;
      widget.bookingItem.foodID = combo['id'];
    });
  }

  void _buildPromoOptions(String? userType) {
    promoOptions = [
      if (userType == 'VIP')
        {'value': 0.1, 'label': 'Thành viên VIP - Giảm 10%'},
      if (userType == 'FRIEND')
        {'value': 0.05, 'label': 'Thành viên FRIEND - Giảm 5%'},
      {'value': 0.0, 'label': 'Không có mã khuyến mãi'},
    ];
  }

  void _updatePromo(String? promoValue) {
    setState(() {
      selectedPromo = promoValue;
      promoDiscount = double.parse(promoValue!);
      widget.bookingItem.totalPrice *= (1 - promoDiscount);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.colors.mainBackground,
        title: Text(
          'Tổng Quan Hóa Đơn',
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
                              'Thời Lượng : ${widget.movie.duration} minutes',
                              style: TextStyle(
                                  color: AppTheme.colors.white,
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Đạo Diễn : ${widget.movie.director}',
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
                              'Thể Loại: ${widget.movie.categories.map((e) => e.categoryName).join(', ')}',
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
                          'Chi Tiết',
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
                            _detailRow('Rạp', cinema),
                            _detailRow('Ghế',
                                widget.bookingItem.seatSymbols.join(', ')),
                            _detailRow(
                              'Ngày đặt',
                              DateFormat('dd/MM/yyyy').format(displayDate),
                            ),
                            _detailRow(
                              'Giờ chiếu',
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
                          'Chi Tiết Giá',
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
                              'Ghế đơn (${singleSeats.length}): ${singleSeats.join(', ')}',
                              singleTotalPrice.toStringAsFixed(0) + ' VNĐ',
                            ),
                            _detailRow(
                              'Ghế đôi (${coupleSeats.length}): ${coupleSeats.join(', ')}',
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
                        _detailRow('Tổng tiền',
                            '${widget.bookingItem.totalPrice.toStringAsFixed(0)} VNĐ')
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Chọn Combo Food',
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
                          'Chọn combo',
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
                            _updatePromo(selectedPromo);
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
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.colors.containerBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      dropdownColor: AppTheme.colors.containerBackground,
                      value: selectedPromo,
                      hint: Text(
                        'Chọn giảm giá',
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
                      items:
                          promoOptions.map<DropdownMenuItem<String>>((promo) {
                        return DropdownMenuItem<String>(
                          value: promo['value'].toString(),
                          child: Text(promo['label']),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        _updatePromo(newValue);
                      },
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
                      onPressed: () async {
                        String paymentUrl =
                            '${dotenv.env['MY_URL']}/payment/create_momo?amount=${widget.bookingItem.totalPrice.toInt()}&scheduleId=${widget.scheduleItem.scheduleId}&comboId=${widget.bookingItem.foodID}&isMobile=true';

                        try {
                          // Gửi dữ liệu lên API /booking trước
                          final bookingResponse = await http.post(
                            Uri.parse('${dotenv.env['MY_URL']}/booking'),
                            headers: {
                              'Content-Type': 'application/json',
                            },
                            body: json.encode({
                              "userID": widget.bookingItem.userID, // Lấy userID từ widget
                              "scheduleID": widget.scheduleItem.scheduleId, // Lấy scheduleID từ widget
                              "seatSymbols": widget.bookingItem.seatSymbols, // Danh sách ghế
                              "foodID": widget.bookingItem.foodID, // ID combo
                              "methodPayment": "MOMO", // Phương thức thanh toán
                              "totalPrice": widget.bookingItem.totalPrice.toInt(), // Tổng tiền
                            }),
                          );

                          if (bookingResponse.statusCode == 200) {
                            // Nếu lưu dữ liệu thành công, tiếp tục tạo thanh toán MoMo
                            final response = await http.get(Uri.parse(paymentUrl));
                            print(response.statusCode);

                            if (response.statusCode == 200) {
                              final jsonResponse = json.decode(response.body);
                              final String? payUrl = jsonResponse['payUrl'];

                              if (payUrl != null) {
                                // Mở ứng dụng MoMo bằng payUrl
                                final Uri payUri = Uri.parse(payUrl);
                                if (await canLaunchUrl(payUri)) {
                                  await launchUrl(payUri, mode: LaunchMode.externalApplication);
                                } else {
                                  throw 'Không thể mở ứng dụng MoMo';
                                }
                              } else {
                                throw 'Không tìm thấy payUrl trong response';
                              }
                            } else {
                              throw 'Lỗi khi tạo thanh toán MoMo';
                            }
                          } else {
                            throw 'Lỗi khi gửi dữ liệu đặt vé lên API';
                          }
                        } catch (e) {
                          print('Lỗi: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Lỗi: $e')),
                          );
                        }
                      },


                      child: Text(
                        'Thanh Toán',
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
