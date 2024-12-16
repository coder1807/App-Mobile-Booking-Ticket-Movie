import 'package:flutter/material.dart';
import 'package:movie_app/Themes/app_theme.dart';

class BookingSummaryMovie extends StatefulWidget {
  const BookingSummaryMovie({super.key});

  @override
  State<BookingSummaryMovie> createState() => _BookingSummaryMovieState();
}

class _BookingSummaryMovieState extends State<BookingSummaryMovie> {
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
        leading: IconButton(icon: const Icon(Icons.arrow_back),
          color: AppTheme.colors.white, onPressed: () {
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
                        child: Image.asset(
                          'assets/images/Poster/poster1.jpg',
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
                              'DEADPOOL 3',
                              style: TextStyle(
                                  color: AppTheme.colors.white,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Duration : 128 minutes',
                              style: TextStyle(
                                  color: AppTheme.colors.white,
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Director : Shown Levy',
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
                                  ':',
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
                                    'R 17+',
                                    style: TextStyle(
                                        color: AppTheme.colors.buttonColor,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Poppins',
                                        fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Genres : Action, Adventure',
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
                            _detailRow('Cinema', 'ABC Cinema'),
                            _detailRow('Package', 'Gold'),
                            _detailRow('Auditorium', 'Auditorium 1'),
                            _detailRow('Seat(s)', 'A1, A2'),
                            _detailRow('Date', '2024-12-01'),
                            _detailRow('Hour', '19:30'),
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
                            _detailRow('Standard (x1)', "\$12.00"),
                            _detailRow('Convenience Free (x1)', '\$1.00'),
                          ],
                        ),
                        Divider(
                          color: AppTheme.colors.greyColor,
                        ),
                        _detailRow('Actual Pay', "\$13.00")
                      ],
                    ),
                  ),
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
}
