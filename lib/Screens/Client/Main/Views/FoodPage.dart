import 'package:flutter/material.dart';
import 'package:movie_app/Themes/app_theme.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.mainBackground,
      body: _page(),
    );
  }

  Widget _page() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            child: Column(
              children: [
                _headerPage(),
                const SizedBox(height: 30),
                _mainPage(),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _headerPage() {
    return Column(
      children: [
        Text(
          'Food',
          style: TextStyle(
            color: AppTheme.colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        _buildPromotionBanner(),
      ],
    );
  }

  Widget _mainPage() {
    return Column(
      children: [
        // Snack list start
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Top Snack',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: AppTheme.colors.white,
              ),
            ),
            Text(
              'View all',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: AppTheme.colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildSnackList(),
        // Snack list end
        // Meal list start
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Meal',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: AppTheme.colors.white,
              ),
            ),
            Text(
              'View all',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: AppTheme.colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildSnackList(),
        // Meal list end
        // Drink list start
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Drink',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: AppTheme.colors.white,
              ),
            ),
            Text(
              'View all',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: AppTheme.colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildSnackList(),
        // Drink list end
      ],
    );
  }

  Widget _buildPromotionBanner() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          'assets/images/Poster/poster4.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildSnackList() {
    // List of snacks with images, names, and prices
    final List<Map<String, dynamic>> snacks = [
      {
        'image': 'assets/images/Foods/popcorn.jpg',
        'name': 'Chips',
        'price': '\$3.99'
      },
      {
        'image': 'assets/images/Foods/hotdog.jpg',
        'name': 'Cookies',
        'price': '\$4.99'
      },
      {
        'image': 'assets/images/Foods/frenchfries.jpg',
        'name': 'Popcorn',
        'price': '\$2.49'
      },
      {
        'image': 'assets/images/Foods/skittles.jpg',
        'name': 'Pretzels',
        'price': '\$3.49'
      },
      {
        'image': 'assets/images/Foods/nachos.jpg',
        'name': 'Pretzels',
        'price': '\$3.49'
      },
      // Add more items as needed
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: snacks.map((snack) => _buildSnackItem(snack)).toList(),
      ),
    );
  }

  Widget _buildSnackItem(Map<String, dynamic> snack) {
    return Container(
      width: 150,
      height: 150,
      margin: EdgeInsets.only(right: 10), // Add spacing between items
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [
            AppTheme.colors.pink.withOpacity(0.8),
            AppTheme.colors.bluePurple.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            // Snack image
            Positioned.fill(
              child: Image.asset(
                snack['image'],
                fit: BoxFit.cover,
              ),
            ),
            // Overlay gradient to make text stand out
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.colors.black.withOpacity(0.4),
                      AppTheme.colors.black.withOpacity(0.1),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            // Snack name and price
            Positioned(
              bottom: 5,
              left: 5,
              right: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snack['name'],
                    style: TextStyle(
                      color: AppTheme.colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    snack['price'],
                    style: TextStyle(
                      color: AppTheme.colors.white,
                      fontSize: 12,
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
}
