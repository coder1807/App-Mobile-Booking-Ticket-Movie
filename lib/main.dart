import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/Screens/Client/Main/Views/Bookings/Payment/PaymentError.dart';
import 'package:movie_app/Screens/Client/Main/Views/CinemaPage.dart';
import 'package:movie_app/Screens/Client/Main/Views/FoodPage.dart';
import 'package:movie_app/Screens/Client/Main/Views/HomePage.dart';
import 'package:movie_app/Screens/Client/Authentication/Views/SignInPage.dart';
import 'package:movie_app/Screens/Client/Main/Views/Profile.dart';
import 'package:movie_app/Screens/Components/BasePage.dart';
import 'package:movie_app/Themes/app_theme.dart';
import 'package:movie_app/manager/UserProvider.dart';
import 'package:provider/provider.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    throw Exception('Error loading .env file: $e');
  }

  final appLinks = AppLinks(); // AppLinks is singleton
  // Subscribe to all events (initial link and further)
  final sub = appLinks.uriLinkStream.listen((uri) {
    // Do something (navigation, ...)
    print("appLink: ${uri.path}");
    // call api toi localhost:8080/api/payment/handlePayment?transaction_id=MOMO1734864017501&json=true
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MyApp(),
    ),
  );
  // runApp(MaterialApp.router(
  //     routerConfig: GoRouter(
  //   routes: [
  //     GoRoute(
  //       path: '/',
  //       builder: (_, __) => MultiProvider(
  //         providers: [
  //           ChangeNotifierProvider(create: (_) => UserProvider()),
  //         ],
  //         child: MyApp(),
  //       ),
  //       routes: [
  //         GoRoute(
  //           path: 'test',
  //           builder: (_, __) {
  //             print("Testtt: ");
  //             return MultiProvider(
  //               providers: [
  //                 ChangeNotifierProvider(create: (_) => UserProvider()),
  //               ],
  //               child: MyApp(),
  //             );
  //           },
  //         ),
  //       ],
  //     ),
  //   ],
  // )));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignInPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  late final List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _children = [
      const HomePageCl(),
      const CinemaPageCl(),
      const FoodPageCl(),
      const ProfilePageCl(),
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
          backgroundColor: Colors.transparent,
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
  const HomePageCl({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasePage(child: HomePage());
  }
}

class CinemaPageCl extends StatelessWidget {
  const CinemaPageCl({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasePage(child: CinemaPage());
  }
}

class FoodPageCl extends StatelessWidget {
  const FoodPageCl({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasePage(child: ListFood());
  }
}

class ProfilePageCl extends StatelessWidget {
  const ProfilePageCl({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasePage(child: ProfilePage());
  }
}
