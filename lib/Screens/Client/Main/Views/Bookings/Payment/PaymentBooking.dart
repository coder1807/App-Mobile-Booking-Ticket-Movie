import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movie_app/Screens/Client/Main/Views/Bookings/Payment/PaymentError.dart';
import 'package:movie_app/Screens/Client/Main/Views/Bookings/Payment/PaymentSuccess.dart';
import 'package:movie_app/Themes/app_theme.dart';

class PaymentBooking extends StatefulWidget {
  const PaymentBooking({super.key});

  @override
  State<PaymentBooking> createState() => _PaymentBookingState();
}

class _PaymentBookingState extends State<PaymentBooking> {
  int _seconds = 300;
  late Timer _timer;
  int? _selectedPaymentIndex;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          timer.cancel();
          Navigator.pop(context);
        }
      });
    });
  }

  String _formatTime() {
    final min = (_seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (_seconds % 60).toString().padLeft(2, '0');
    return "$min:$sec";
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget _buildPaymentMethod(String image, String title, int index,
      {String? cardNumber}) {
    bool isSelected = _selectedPaymentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentIndex = index;
        });
      },
      child: Container(
        height: 80,
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 10, 21, 52),
          borderRadius: BorderRadius.circular(10),
          border: isSelected ? Border.all(color: Colors.white, width: 1) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.colors.white,
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Text(
                cardNumber != null
                    ? '${'*' * (cardNumber.length - 4)}${cardNumber.substring(cardNumber.length - 4)}'
                    : title,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    color: AppTheme.colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.colors.mainBackground,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Choose Payment Method',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: AppTheme.colors.white),
            ),
            Text(
              _formatTime(),
              style: TextStyle(
                  color: AppTheme.colors.buttonColor,
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: AppTheme.colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: AppTheme.colors.mainBackground),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildPaymentMethod(
                    'assets/images/Payment/Paypal.jpg', 'Paypal', 0),
                _buildPaymentMethod(
                    'assets/images/Payment/googlePay.jpg', 'Google Pay', 1),
                _buildPaymentMethod(
                    'assets/images/Payment/applesStore.jpg', 'Apple Store', 2),
                _buildPaymentMethod(
                    'assets/images/Payment/visa.jpg', '**** 4973', 3,
                    cardNumber: '1368497534973'),
                _buildPaymentMethod(
                    'assets/images/Payment/masterCard.jpg', '**** 4973', 4,
                    cardNumber: '1368497534973'),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    if (_selectedPaymentIndex == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select a payment method"),
                        ),
                      );
                      return;
                    }
                    if (_selectedPaymentIndex == 3) {
                      // Visa
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PaymentSuccessPage()),
                      );
                    } else if (_selectedPaymentIndex == 4) {
                      // MasterCard
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PaymentErrorPage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text("This payment method is not yet supported"),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.colors.orange,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30),
                  ),
                  child: Stack(
                    children: [
                      Text(
                        "Confirm Payment - \$50.00",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: AppTheme.colors.white),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
