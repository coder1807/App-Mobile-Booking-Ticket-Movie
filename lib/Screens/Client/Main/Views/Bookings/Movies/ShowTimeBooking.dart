import 'package:flutter/material.dart';
import 'package:movie_app/Themes/app_theme.dart';

class ShowTimeBookingPage extends StatefulWidget {
  const ShowTimeBookingPage({super.key});

  @override
  State<ShowTimeBookingPage> createState() => _ShowTimeBookingPageState();
}

class _ShowTimeBookingPageState extends State<ShowTimeBookingPage> {
  int selectedDateIndex = -1;
  int selectedShowtimeIndex = -1;

  final List<Map<String, String>> dates = [
    {'day': '25', 'title': 'Mon'},
    {'day': '26', 'title': 'Tue'},
    {'day': '27', 'title': 'Wed'},
    {'day': '28', 'title': 'Thu'},
    {'day': '29', 'title': 'Fri'},
  ];

  final List<String> showtime = [
    '10:00 AM',
    '12:00 PM',
    '3:00 PM',
    '6:00 PM',
    '9:00 PM'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppTheme.colors.mainBackground,
          title: Text('Choose Date and Time',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.colors.white)),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 25,
              color: AppTheme.colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: AppTheme.colors.mainBackground),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Google Map Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 250,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Text(
                          'Google Map Here',
                          style: TextStyle(color: Colors.black45),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Title
                  Text(
                    'AMC Empire 25',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.colors.white,
                        fontFamily: 'Poppins'),
                  ),
                  const SizedBox(height: 8),
                  // Rating Row
                  Row(
                    children: [
                      Row(
                        children: List.generate(
                            5,
                            (index) => const Icon(Icons.star,
                                color: Color.fromARGB(255, 230, 193, 59),
                                size: 20)),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '4.5',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                            color: AppTheme.colors.white,
                            fontSize: 12),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(1234 Google reviews)',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: AppTheme.colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Location Row
                  Row(
                    children: [
                      Icon(Icons.location_on, color: AppTheme.colors.white),
                      const SizedBox(width: 8),
                      Text('123 Main St, New York, NY',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: AppTheme.colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Phone Row
                  Row(
                    children: [
                      Icon(Icons.phone, color: AppTheme.colors.white),
                      const SizedBox(width: 8),
                      Text('(123) 456-7890',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: AppTheme.colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Date List
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: dates.asMap().entries.map((entry) {
                        int index = entry.key;
                        Map<String, String> date = entry.value;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDateIndex = index;
                            });
                          },
                          child: Container(
                            width: 80,
                            height: 80,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: selectedDateIndex == index
                                  ? AppTheme.colors.orange
                                  : Colors.transparent,
                              border: Border.all(
                                color: selectedDateIndex == index
                                    ? AppTheme.colors.orange
                                    : Colors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  date['day']!,
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: AppTheme.colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(date['title']!,
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: AppTheme.colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 16),
                  // Standard and Auditorium
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Standard (\$12.00)',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: AppTheme.colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        'Auditorium 3',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: AppTheme.colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: showtime.asMap().entries.map((entry) {
                      int index = entry.key;
                      String showtime = entry.value;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedShowtimeIndex = index;
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 50,
                          decoration: BoxDecoration(
                            color: selectedShowtimeIndex == index
                                ? AppTheme.colors.orange
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: selectedDateIndex == index
                                  ? AppTheme.colors.greyColor
                                  : Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              showtime,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                  color: AppTheme.colors.white),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 25),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: AppTheme.colors.buttonColor,
                        ),
                        child: Text(
                          'Continue',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.colors.white,
                              fontFamily: 'Poppins'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
