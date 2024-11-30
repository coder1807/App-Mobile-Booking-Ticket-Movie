// ignore: file_names
import 'package:flutter/material.dart';
import 'package:movie_app/Themes/app_theme.dart';

class PaymentErrorPage extends StatelessWidget {
  const PaymentErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: AppTheme.colors.black.withOpacity(0.7),
          ),
          Center(
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 500,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/Payment/paymentError.jpg',
                        height: 200,
                        width: 300,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Oops! Something went wrong',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.colors.buttonColor),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Your order could not be processed. Please try again later.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 30),
                      Column(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.colors.black,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              child: Text(
                                'Back to Home',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: AppTheme.colors.white,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 10,
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: AppTheme.colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
