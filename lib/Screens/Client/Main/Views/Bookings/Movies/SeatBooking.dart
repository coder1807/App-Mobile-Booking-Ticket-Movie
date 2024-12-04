import 'package:flutter/material.dart';
import 'package:movie_app/Themes/app_theme.dart';

class SeatBooking extends StatefulWidget {
  const SeatBooking({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SeatBookingState createState() => _SeatBookingState();
}

class _SeatBookingState extends State<SeatBooking> {
  final List<String> seatRows = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'L'];
  final int seatsPerRow = 8;
  final double singleSeatPrice = 13.0;
  final double coupleSeatPrice = 25.0;
  final List<String> coupleSeats = [
    'H1',
    'H2',
    'H3',
    'H4',
    'H5',
    'H6',
    'H7',
    'H8',
    'L1',
    'L2',
    'L3',
    'L4',
    'L5',
    'L6',
    'L7',
    'L8',
  ];
  List<String> selectedSeats = [];
  List<String> bookedSeats = ['A5', 'A6', 'B3', 'F6', 'F7'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.colors.mainBackground,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: AppTheme.colors.white),
        title:
            Text("Your Seat", style: TextStyle(color: AppTheme.colors.white)),
        centerTitle: true,
      ),
      body: Container(
        color: AppTheme.colors.mainBackground,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text("CINEMA SCREEN",
                style: TextStyle(
                    color: AppTheme.colors.pink,
                    fontFamily: 'Poppins',
                    fontSize: 16)),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: 2,
              width: double.infinity,
              color: Colors.pinkAccent,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLegend(Icons.chair, AppTheme.colors.white, "Available"),
                  _buildLegend(Icons.chair, AppTheme.colors.pink, "Your Seat"),
                  _buildLegend(
                      Icons.chair, AppTheme.colors.orangeColor, "Couple"),
                  _buildLegend(
                      Icons.chair, AppTheme.colors.greyColor, "Booked"),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: seatsPerRow,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 15,
                  childAspectRatio: 0.6,
                ),
                itemCount: seatRows.length * seatsPerRow,
                itemBuilder: (context, index) {
                  String seat = seatRows[index ~/ seatsPerRow] +
                      (index % seatsPerRow + 1).toString();
                  Color seatColor;
                  bool isCoupleSeat = coupleSeats.contains(seat);
                  if (bookedSeats.contains(seat)) {
                    seatColor = AppTheme.colors.greyColor;
                  } else if (selectedSeats.contains(seat)) {
                    seatColor = AppTheme.colors.pink;
                  } else {
                    seatColor = isCoupleSeat
                        ? AppTheme.colors.orangeColor
                        : AppTheme.colors.white;
                  }

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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chair,
                          size: isCoupleSeat ? 40 : 30,
                          color: seatColor,
                        ),
                        Text(
                          seat,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            color: AppTheme.colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
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
                      Text(
                        selectedSeats.join(', '),
                        style: TextStyle(color: AppTheme.colors.pink),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text("Total Price",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        "\$${calculateTotalPrice().toStringAsFixed(2)}",
                        style: TextStyle(color: AppTheme.colors.pink),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => const FoodBooking()),
                      // );
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
}
