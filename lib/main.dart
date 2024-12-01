import 'package:flutter/material.dart';
import 'package:movie_app/Screens/Client/Authentication/Views/SignInPage.dart';
import 'package:movie_app/Screens/Client/Main/Views/CinemaPage.dart';
import 'package:movie_app/Screens/Client/Main/Views/FoodPage.dart';
import 'package:movie_app/Screens/Client/Main/Views/HomePage.dart';
import 'package:movie_app/Screens/Client/Main/Views/Profile.dart';
import 'package:movie_app/Themes/app_theme.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignInPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage();
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  late final List<Widget> _children;
  @override
  void initState() {
    super.initState();
    _children = [
      HomePageCl(),
      CinemaPageCl(),
      FoodPageCl(),
      ProfilePageCl(),
    ];
  }

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildBottomNavigationBar() {
    return Stack(
      children: [
        Container(
          height: 60,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF431C81), Color(0xFF4E69AD), Color(0xFF9B4AAB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent, // Làm trong suốt
          unselectedItemColor: AppTheme.colors.blueSky,
          selectedItemColor: AppTheme.colors.white,
          currentIndex: _currentIndex,
          onTap: onTappedBar,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.theaters),
              label: 'Cinemas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fastfood),
              label: 'Food Order',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}

class HomePageCl extends StatelessWidget {
  HomePageCl();

  @override
  Widget build(BuildContext context) {
    return Center(child: HomePage());
  }
}

class CinemaPageCl extends StatelessWidget {
  CinemaPageCl();
  @override
  Widget build(BuildContext context) {
    return Center(child: CinemaPage());
  }
}

class FoodPageCl extends StatelessWidget {
  FoodPageCl();
  @override
  Widget build(BuildContext context) {
    return Center(child: FoodPage());
  }
}

class ProfilePageCl extends StatelessWidget {
  ProfilePageCl();
  @override
  Widget build(BuildContext context) {
    return Center(child: ProfilePage());
  }
}
