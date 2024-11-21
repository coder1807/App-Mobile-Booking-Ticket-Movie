import 'package:flutter/material.dart';
import 'package:movie_app/Themes/app_theme.dart';

class FoodBooking extends StatefulWidget {
  const FoodBooking({super.key});

  @override
  State<FoodBooking> createState() => _FoodBookingState();
}

class _FoodBookingState extends State<FoodBooking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), // Chiều cao của AppBar
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          child: AppBar(
            backgroundColor: AppTheme.colors.mainBackground,
            title: Text(
              'Detail Order',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            centerTitle: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0), // Padding cho icon
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 20, // Thay đổi kích thước icon
                  color: AppTheme.colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Xử lý quay lại
                },
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Text('Food Booking Content'),
      ),
    );
  }
}
