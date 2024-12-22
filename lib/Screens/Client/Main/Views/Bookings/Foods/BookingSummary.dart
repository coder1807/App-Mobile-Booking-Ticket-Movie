import 'package:flutter/material.dart';
import 'package:movie_app/Themes/app_theme.dart';

class BookingSummaryFoods extends StatefulWidget {
  const BookingSummaryFoods({super.key});

  @override
  State<BookingSummaryFoods> createState() => _BookingSummaryFoodsState();
}

class _BookingSummaryFoodsState extends State<BookingSummaryFoods> {
  String? selectedTime;
  int foodQuantity = 2;
  double foodPrice = 15.0;
  double serviceFee = 2.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Summary',
          style: TextStyle(
              fontSize: 18,
              fontFamily: 'Poppins',
              color: AppTheme.colors.white,
              fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.colors.mainBackground,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: AppTheme.colors.white,
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                '5:00',
                style: TextStyle(
                    color: AppTheme.colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 16),
              ),
            ),
          )
        ],
      ),
      body: _page(),
    );
  }

  Widget _page() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(color: AppTheme.colors.mainBackground),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.colors.pink.withOpacity(0.8),
                          AppTheme.colors.bluePurple.withOpacity(0.6),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      image: const DecorationImage(
                          image: AssetImage('assets/images/Foods/popcorn.jpg'),
                          fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Delicious Food',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.colors.white,
                                  fontFamily: 'Poppins'),
                            ),
                            Text(
                              'x$foodQuantity',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  color: AppTheme.colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${(foodQuantity * foodPrice).toStringAsFixed(2)}',
                              style: TextStyle(
                                  color: AppTheme.colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins'),
                            ),
                            Icon(
                              Icons.edit,
                              color: AppTheme.colors.white,
                              size: 16,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.red, width: 2)),
                    child: Center(
                      child: selectedTime == null
                          ? Icon(
                              Icons.access_time,
                              color: AppTheme.colors.buttonColor,
                              size: 14,
                            )
                          : Text(
                              selectedTime!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.colors.white),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Choose pick up time',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              color: AppTheme.colors.buttonColor),
                        ),
                        Text(
                          'You need to choose pick up time',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: AppTheme.colors.white),
                        )
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final time = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());
                      if (time != null) {
                        setState(() {
                          selectedTime = time.format(context);
                        });
                      }
                    },
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: AppTheme.colors.white,
                      size: 20,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 200,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 58, 50, 97),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price Details',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: AppTheme.colors.white),
                    ),
                    const Divider(),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delicious Food',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins',
                              color: AppTheme.colors.white),
                        ),
                        Text(
                          '\$${(foodQuantity * foodPrice).toStringAsFixed(2)}',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: AppTheme.colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Service Feed',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: AppTheme.colors.white),
                        ),
                        Text(
                          '\$${(serviceFee).toStringAsFixed(2)}',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: AppTheme.colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Actual payment',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: AppTheme.colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$${(foodQuantity * foodPrice + serviceFee).toStringAsFixed(2)}',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: AppTheme.colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Promo & Voucher',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: AppTheme.colors.white),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                style: TextStyle(color: AppTheme.colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter the promo code or voucher',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '- Purchase and pick up the foods or drinks can only be done on the same day.',
                style:
                    TextStyle(fontSize: 12, color: AppTheme.colors.greyColor),
              ),
              Text(
                '- If you order food and drinks to watch a movie. we recommended picking it up 10 minutes before the movie start ',
                style:
                    TextStyle(fontSize: 12, color: AppTheme.colors.greyColor),
              ),
              const Divider(),
              const Spacer(),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: AppTheme.colors.buttonColor),
                child: Text(
                  'Proceed to payment',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: AppTheme.colors.white,
                      fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
