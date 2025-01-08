import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/Screens/Client/Main/Model/BookingItem.dart';
import 'package:movie_app/Screens/Client/Main/Model/MovieItem.dart';
import 'package:movie_app/Screens/Client/Main/Model/ScheduleItem.dart';
import 'package:movie_app/Screens/Client/Main/Views/Bookings/Foods/BookingSummary.dart';
import 'dart:convert';

import 'package:movie_app/Themes/app_theme.dart';
import 'package:movie_app/Screens/Client/Main/Views/Bookings/Movies/BookingSummary.dart';
import 'package:movie_app/manager/UserProvider.dart';
import 'package:movie_app/models/movie.dart';
import 'package:provider/provider.dart';

class SeatBooking extends StatefulWidget {
  final ScheduleItem schedule;
  final int roomId;
  final MovieItem movie;

  const SeatBooking(
      {super.key,
        required this.schedule,
        required this.roomId,
        required this.movie});

  @override
  _SeatBookingState createState() => _SeatBookingState();
}

class _SeatBookingState extends State<SeatBooking> {
  final List<String> singleSeatRows = ['A', 'B', 'C', 'D', 'E', 'F'];
  final List<String> coupleSeatRows = ['G'];
  Map<String, String> seatTypeMap = {};

  final int singleSeatsPerRow = 10;
  final int coupleSeatsPerRow = 6;

  final double singleSeatPrice = 80000;
  final double coupleSeatPrice = 120000;

  final List<String> coupleSeats = [
    'G1',
    'G2',
    'G3',
    'G4',
    'G5',
    'G6',
    'G7',
    'G8',
    'G9',
    'G10',
    'G11',
    'G12',
    'G13',
    'G14',
    'G15',
    'G16'
  ];

  List<String> selectedSeats = [];
  List<String> bookedSeats = []; // Ghế đã đặt sẽ được lưu ở đây
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBookedSeats();
  }

  // Gọi API để lấy danh sách ghế đã đặt
  Future<void> _fetchBookedSeats() async {
    final baseUrl = dotenv.env['MY_URL']; // Thay đổi URL cho phù hợp

    try {
      final response = await http.get(Uri.parse('$baseUrl/seats/${widget.schedule.scheduleId}'));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          if (responseData.isNotEmpty) {
            bookedSeats = responseData.map((seat) => seat['symbol'] as String).toList();
          } else {
            bookedSeats = []; // Nếu không có ghế nào được đặt, bookedSeats vẫn là danh sách trống
          }
          isLoading = false; // Đã xong việc lấy dữ liệu, dừng loading
        });
      } else {
        // Xử lý lỗi nếu API không thành công
        print('Error fetching booked seats: ${response.statusCode}');
        setState(() {
          isLoading = false; // Dừng loading ngay cả khi có lỗi
        });
      }
    } catch (e) {
      print('Error fetching booked seats: $e');
      setState(() {
        isLoading = false; // Dừng loading khi có lỗi
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.colors.mainBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppTheme.colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("ĐẶT GHẾ", style: TextStyle(color: AppTheme.colors.white)),
        centerTitle: true,
      ),
      body: Container(
        color: AppTheme.colors.mainBackground,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text("MÀN HÌNH",
                style: TextStyle(color: AppTheme.colors.pink, fontFamily: 'Poppins', fontSize: 16)),
            Image.asset('assets/images/Movies/screen-thumb.png'),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: 2,
              width: double.infinity,
              color: Colors.pinkAccent,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 30,),// Space for pushing first column to the right
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLegend(Icons.square_rounded, AppTheme.colors.white, "Có sẵn"),
                          SizedBox(height: 5,),
                          _buildLegend(Icons.rectangle_rounded, AppTheme.colors.orangeColor, "Ghế đôi"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLegend(Icons.square_rounded, AppTheme.colors.pink, "Ghế đã chọn"),
                          SizedBox(height: 5,),
                          _buildLegend(Icons.square_rounded, Colors.grey[800]!, "Ghế đã đặt"),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomScrollView(
                      slivers: [
                        _buildSingleSeatsSection(),
                        _buildCoupleSeatsSection(),
                      ],
                    ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Ghế đã chọn", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(selectedSeats.join(', '), style: TextStyle(color: AppTheme.colors.pink)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text("Tổng tiền", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("${calculateTotalPrice().toStringAsFixed(0)} VNĐ",
                          style: TextStyle(color: AppTheme.colors.pink)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final bookingItem = BookingItem(
                        Provider.of<UserProvider>(context, listen: false).user!.id,
                        widget.schedule.scheduleId,
                        selectedSeats,
                        0,
                        "",
                        calculateTotalPrice(),
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingSummaryMovie(
                            bookingItem: bookingItem,
                            movie: widget.movie,
                            scheduleItem: widget.schedule,
                            seatTypeMap: seatTypeMap,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("Thanh Toán",
                        style: TextStyle(fontFamily: 'Poppins', color: AppTheme.colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeatWidget(String seat, {bool isCouple = false}) {
    Color seatColor;
    bool isCoupleRow = coupleSeatRows.contains(seat[0]);

    if (isCoupleRow) {
      int seatNumber = int.parse(seat.substring(1));
      bool isFirstInCouplePair = seatNumber % 2 == 1;

      if (isFirstInCouplePair) {
    }
    if (bookedSeats.contains(seat)) {
      seatColor = Colors.grey[800]!;
    } else if (selectedSeats.contains(seat)) {
      seatColor = AppTheme.colors.pink;
    } else {
      seatColor = isCoupleRow ? AppTheme.colors.orangeColor : AppTheme.colors.white;
    }

    TextStyle textStyle = TextStyle(
      fontSize: 12,
      fontWeight: bookedSeats.contains(seat) ? FontWeight.bold : FontWeight.w600,
      color: seatColor == AppTheme.colors.white ? Colors.black : Colors.white,
    );

    return GestureDetector(
      onTap: bookedSeats.contains(seat)
          ? null
          : () {
        setState(() {
          if (selectedSeats.contains(seat)) {
            selectedSeats.remove(seat);
            seatTypeMap.remove(seat);
          } else {
            selectedSeats.add(seat);
            color: seatColor,
          ),
          Padding(
            padding: isCoupleRow
                ? const EdgeInsets.fromLTRB(6, 0, 0, 0)
                : const EdgeInsets.fromLTRB(3, 0, 0, 0),
            child: SizedBox(
              width: isCoupleRow ? 70 : 45,
              height: isCoupleRow ? 70 : 45, // Increased height for two lines
              child: Center(
                child: isCoupleRow
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            firstSeat,
                            style: textStyle,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            secondSeat,
                            style: textStyle,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    : Text(
                        seat,
                        style: textStyle,
                        textAlign: TextAlign.center,
                      ),
              ),
            ),
          ),

            size: isCoupleRow ? 65 : 45, // increased icon size
            color: seatColor,
          ),
          Padding(
            padding:isCoupleRow ? const EdgeInsets.fromLTRB(6, 0,0, 0) :const EdgeInsets.fromLTRB(3, 0,0, 0),
            child: SizedBox(
              width: isCoupleRow ? 60: 45,
              child: Center(
                child: Text(
                  seat,
                  style: textStyle,
                  textAlign: TextAlign.center,
                  maxLines: isCoupleRow ? 2 : 1, // Enable wrapping for couple seats
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
          )

        ],
      ),
    );
  }

  Widget _buildLegend(IconData icon, Color color, String label) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.colors.white,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _buildSingleSeatsSection() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 16.0, 0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 9,
          mainAxisSpacing: 5,
          crossAxisSpacing: .5,
          childAspectRatio: 0.5,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            int rowIndex = index ~/ 9;
            int colIndex = index % 9 + 1;

            String seat = '${singleSeatRows[rowIndex]}$colIndex';
  Widget _buildCoupleSeatsSection() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 16.0, 0),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            int rowIndex = index ~/ coupleSeatsPerRow;
            String seat = coupleSeatRows[rowIndex] +
                (index % coupleSeatsPerRow * 2 + 1).toString();
          },
          childCount: coupleSeatRows.length * coupleSeatsPerRow,
        ),
      ),
    );
  }

  double calculateTotalPrice() {
    double total = 0;
      if (coupleSeats.contains(seat)) {

        total += coupleSeatPrice;
      } else {
        total += singleSeatPrice;
      }
    }
    return total;
  }
}

/*  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.colors.mainBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppTheme.colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        color: AppTheme.colors.mainBackground,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text("MÀN HÌNH",
                style: TextStyle(
                    color: AppTheme.colors.pink,
                    fontFamily: 'Poppins',
                    fontSize: 16)),
            Image.asset('assets/images/Movies/screen-thumb.png'),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: 2,
              width: double.infinity,
              color: Colors.pinkAccent,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLegend(
                      Icons.square_rounded, AppTheme.colors.white, "Available"),
                  _buildLegend(
                      Icons.square_rounded, AppTheme.colors.pink, "Your Seat"),
                  _buildLegend(Icons.square_rounded,
                      AppTheme.colors.orangeColor, "Couple"),
                  _buildLegend(
                      Icons.square_rounded, AppTheme.colors.blueSky, "Booked"),
                ],
              ),
            ),
            Expanded(
              child: isLoading // Chờ cho ghế đã đặt được tải về từ API
                  ? const Center(child: CircularProgressIndicator())
                  : CustomScrollView(
                      slivers: [
                        // Phần ghế single
                        SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: singleSeatsPerRow,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 2,
                            childAspectRatio: 0.6,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              int rowIndex = index ~/ singleSeatsPerRow;
                              String seat = singleSeatRows[rowIndex] +
                                  (index % singleSeatsPerRow + 1).toString();
                              return _buildSeatWidget(seat);
                            },
                            childCount:
                                singleSeatRows.length * singleSeatsPerRow,
                          ),
                        ),

                        // Phần ghế couple
                        SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                coupleSeatsPerRow, // Đã điều chỉnh thành 4
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 8,
                            childAspectRatio: 0.6,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              int rowIndex = index ~/ coupleSeatsPerRow;
                              String seat = coupleSeatRows[rowIndex] +
                                  (index % coupleSeatsPerRow * 2 + 1)
                                      .toString(); // Điều chỉnh để lấy các số lẻ
                              return _buildSeatWidget(seat, isCouple: true);
                            },
                            childCount: coupleSeatRows.length *
                                coupleSeatsPerRow, // Vẫn giữ số lượng ban đầu
                          ),
                        ),
                      ],
                    ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, -2)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Your Seat",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(selectedSeats.join(', '),
                          style: TextStyle(color: AppTheme.colors.pink)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text("Total Price",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("${calculateTotalPrice().toStringAsFixed(0)} VNĐ",
                          style: TextStyle(color: AppTheme.colors.pink)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final bookingItem = BookingItem(
                        Provider.of<UserProvider>(context, listen: false)
                            .user!
                            .id,
                        this.widget.schedule.scheduleId,
                        selectedSeats,
                        0,
                        "",
                        calculateTotalPrice(),
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BookingSummaryMovie(
                                  bookingItem: bookingItem,
                                  movie: this.widget.movie,
                                  scheduleItem: widget.schedule,
                                  seatTypeMap: seatTypeMap,
                                )),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("Next",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: AppTheme.colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildSeatWidget(String seat, {bool isCouple = false}) {
    Color seatColor;
    bool isCoupleRow = coupleSeatRows.contains(seat[0]);

    if (isCoupleRow) {
      int seatNumber = int.parse(seat.substring(1));
      bool isFirstInCouplePair = seatNumber % 2 == 1;

      if (isFirstInCouplePair) {
        seat = '${seat[0]}${seatNumber}${seat[0]}${seatNumber + 1}';
      } else {
        return SizedBox.shrink();
      }
    }

    if (bookedSeats.contains(seat)) {
      seatColor = Colors.grey[800]!;
    } else if (selectedSeats.contains(seat)) {
      seatColor = AppTheme.colors.pink; // Màu ghế đã chọn
    } else {
      seatColor = isCouple
          ? AppTheme.colors.orangeColor
          : AppTheme.colors.white; // Màu ghế còn trống
    }

    TextStyle textStyle = TextStyle(
      fontSize: 12, // Tăng kích thước chữ nếu cần
      fontWeight:
          bookedSeats.contains(seat) ? FontWeight.bold : FontWeight.w600,
      color: seatColor == AppTheme.colors.white ? Colors.black : Colors.white,
    );

    return GestureDetector(
      onTap: bookedSeats.contains(seat)
          ? null
          : () {
              setState(() {
                if (selectedSeats.contains(seat)) {
                  selectedSeats.remove(seat);
                  seatTypeMap.remove(seat);
                } else {
                  selectedSeats.add(seat);
                  if (coupleSeats.contains(seat))
                    seatTypeMap[seat] = 'couple';
                  else
                    seatTypeMap[seat] = 'single';
                }
              });
            },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isCoupleRow ? Icons.rectangle_rounded : Icons.square_rounded,
            size: isCoupleRow ? 60 : 40,
            color: seatColor,
          ),
          if (!isCoupleRow)
            Center(
              child: Text(
                '  ' + '$seat',
                style: textStyle,
                textAlign: TextAlign.center,
              ),
            ),
          if (isCoupleRow)
            Text(
              seat,
              style: textStyle,
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  Widget _buildLegend(IconData icon, Color color, String label) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(
                fontSize: 14,
                color: AppTheme.colors.white,
                fontFamily: 'Poppins')),
      ],
    );
  }

  Widget _buildSingleSeatsSection() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 12, // Tăng số cột lên để tạo khoảng trống ở giữa
          mainAxisSpacing: 15,
          crossAxisSpacing: 2,
          childAspectRatio: 0.5,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            int rowIndex = index ~/ 12; // Số cột mới
            int colIndex = index % 12; // Vị trí trong hàng

            // Bỏ qua 2 cột ở giữa (cột 5 và 6)
            if (colIndex == 5 || colIndex == 6) {
              return const SizedBox(); // Khoảng trống ở giữa
            }

            // Tính số ghế thực tế
            int actualSeatNumber;
            if (colIndex < 5) {
              actualSeatNumber = colIndex + 1; // Ghế 1-5 bên trái
            } else {
              actualSeatNumber = colIndex - 1; // Ghế 6-10 bên phải
            }

            String seat = '${singleSeatRows[rowIndex]}$actualSeatNumber';
            return _buildSeatWidget(seat);
          },
          childCount: singleSeatRows.length * 12, // Số cột mới
        ),
      ),
    );
  }*/
