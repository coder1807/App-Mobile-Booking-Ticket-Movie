import 'package:flutter/material.dart';
import 'package:movie_app/Themes/app_theme.dart';

class DetailFood extends StatefulWidget {
  const DetailFood({super.key});

  @override
  State<DetailFood> createState() => _DetailFoodState();
}

class _DetailFoodState extends State<DetailFood> {
  int foodQuantity = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.colors.mainBackground,
          title: Text(
            'Detail Food',
            style: TextStyle(
              fontSize: 18,
              color: AppTheme.colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 20,
                color: AppTheme.colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        body: _page());
  }

  Widget _page() {
    return Stack(
      children: [
        Container(
          color: AppTheme.colors.mainBackground,
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.colors.pink.withOpacity(0.8),
                      AppTheme.colors.bluePurple.withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  image: const DecorationImage(
                      image: AssetImage('assets/images/Foods/popcorn.jpg'),
                      fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Delicious Food',
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: AppTheme.colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'This is a short description of the food, made with fresh ingredient an',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    color: AppTheme.colors.white),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppTheme.colors.white,
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          if (foodQuantity > 1) foodQuantity--;
                        });
                      },
                      icon: Icon(
                        Icons.remove,
                        color: AppTheme.colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '$foodQuantity',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        color: AppTheme.colors.white),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppTheme.colors.white,
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          foodQuantity++;
                        });
                      },
                      icon: Icon(
                        Icons.add,
                        size: 24,
                        color: AppTheme.colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Note for your food and drink',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: AppTheme.colors.white),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: 'Enter your note here',
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: AppTheme.colors.greyColor,
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppTheme.colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.colors.buttonColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Row(
                      children: [
                        Text(
                          'Payment',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppTheme.colors.white),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '\$${(foodQuantity * 15).toStringAsFixed(2)}',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: AppTheme.colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
