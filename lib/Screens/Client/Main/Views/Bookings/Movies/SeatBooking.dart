import 'package:flutter/material.dart';
import 'package:movie_app/Screens/Client/Main/Views/Bookings/Foods/BookingSummary.dart';
import 'package:movie_app/Screens/Client/Main/Views/Bookings/Movies/BookingSummary.dart';
import 'package:movie_app/Themes/app_theme.dart';

class SeatBooking extends StatefulWidget {
  final int scheduleId;
  final int roomId;
  const SeatBooking({super.key, required this.scheduleId, required this.roomId});

  @override
  // ignore: library_private_types_in_public_api
  _SeatBookingState createState() => _SeatBookingState();
}

class _SeatBookingState extends State<SeatBooking> {
  // Danh sách các hàng ghế single
  final List<String> singleSeatRows = ['A', 'B', 'C', 'D', 'E', 'F', ];

  // Danh sách các hàng ghế couple
  final List<String> coupleSeatRows = ['G'];

  final int singleSeatsPerRow = 10;
  final int coupleSeatsPerRow = 6;

  final double singleSeatPrice = 13.0;
  final double coupleSeatPrice = 25.0;

  final List<String> coupleSeats = [
    'G1', 'G2', 'G3', 'G4', 'G5', 'G6', 'G7', 'G8','G9','G10','G11','G12',
  ];

  List<String> selectedSeats = [];
  List<String> bookedSeats = ['A5', 'A6', 'B3', 'F6', 'F7'];

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
                  _buildLegend(Icons.square_rounded, AppTheme.colors.white, "Có sẵn"),

                   _buildLegend(Icons.square_rounded, AppTheme.colors.pink, "Ghế đã chọn"),
                  _buildLegend(Icons.rectangle_rounded, AppTheme.colors.orangeColor, "Ghế đôi"),
                  _buildLegend(Icons.square_rounded, Colors.grey[800]!, "Ghế đã đặt"),

                ],
              ),
            ),
            Expanded(//tên vô giữa icon, 2 cột 1 bên 5 ghế, available nền đen chữ trắng
                // , booked xám đậm chữ trắng bold
              child: CustomScrollView(
                slivers: [
                  // Phần ghế single
                  _buildSingleSeatsSection(),

                  // Phần ghế couple
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: coupleSeatsPerRow, // Đã điều chỉnh thành 4
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.6,
                    ),
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        int rowIndex = index ~/ coupleSeatsPerRow;
                        String seat = coupleSeatRows[rowIndex] +
                            (index % coupleSeatsPerRow * 2 + 1).toString(); // Điều chỉnh để lấy các số lẻ
                        return _buildSeatWidget(seat, isCouple: true);
                      },
                      childCount: coupleSeatRows.length * coupleSeatsPerRow, // Vẫn giữ số lượng ban đầu
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
                      color: Colors.black12, blurRadius: 4, offset: Offset(0, -2)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Gh đã chọn",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        selectedSeats.join(', '),
                        style: TextStyle(color: AppTheme.colors.pink),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text("Tổng tiền",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        "\$${calculateTotalPrice().toStringAsFixed(2)}",
                        style: TextStyle(color: AppTheme.colors.pink),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BookingSummaryMovie()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Next",
                      style: TextStyle(
                          fontFamily: 'Poppins', color: AppTheme.colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double calculateTotalPrice() {
    double total = 0;
    for (String seat in selectedSeats) {
      if (coupleSeats.contains(seat)) {
        total += coupleSeatPrice;
      } else {
        total += singleSeatPrice;
      }
    }
    return total;
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
      seatColor = AppTheme.colors.pink;
    } else {
      seatColor = isCoupleRow ? AppTheme.colors.orangeColor : AppTheme.colors.white;
    }

    TextStyle textStyle = TextStyle(
      fontSize: 12, // Tăng kích thước chữ nếu cần
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
          } else {
            selectedSeats.add(seat);
          }
        });
      },
      child: Stack(
        alignment: Alignment.center, // Đảm bảo căn giữa text
        children: [
          Icon(
            isCoupleRow ? Icons.rectangle_rounded : Icons.square_rounded,
            size: isCoupleRow ? 60: 40,
            color: seatColor,
          ),
          if(!isCoupleRow)
            Center(
              child: Text(
                '  ' + '$seat',
                style: textStyle,
                textAlign: TextAlign.center,
              ),
            ),

          if(isCoupleRow)
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
            textAlign: TextAlign.center,
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
          mainAxisSpacing:15,
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
  }
}
