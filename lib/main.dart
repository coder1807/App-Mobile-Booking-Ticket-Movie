import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/Api/auth/login.dart';
import 'package:movie_app/Screens/Client/Authentication/Views/ResetPasswordPage.dart';
import 'package:movie_app/Screens/Client/Main/Views/BlogPage.dart';
import 'package:movie_app/Screens/Client/Main/Views/Bookings/Payment/PaymentError.dart';
import 'package:movie_app/Screens/Client/Main/Views/CinemaPage.dart';
import 'package:movie_app/Screens/Client/Main/Views/HomePage.dart';
import 'package:movie_app/Screens/Client/Authentication/Views/SignInPage.dart';
import 'package:movie_app/Screens/Client/Main/Views/MyTicketsPage.dart';
import 'package:movie_app/Screens/Client/Main/Views/Profile.dart';
import 'package:movie_app/Screens/Components/BasePage.dart';
import 'package:movie_app/Themes/app_theme.dart';
import 'package:movie_app/firebase_options.dart';
import 'package:movie_app/manager/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await dotenv.load(fileName: ".env");
  } catch (e) {
    throw Exception('Error loading .env file: $e');
  }

  bool skipLogin = await isLogined();
  print("skipLogin: ${skipLogin ? "Đã bỏ qua đăng nhập." : "Chưa đăng nhập."}");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MyApp(skipLogin: skipLogin),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  final bool skipLogin;

  const MyApp({super.key, required this.skipLogin});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _initDeepLinkListener();
  }

  void _initDeepLinkListener() async {
    final initialUri = await getInitialUri();
    if (initialUri != null) {
      _handleDeepLink(initialUri);
    }

    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    }, onError: (err) {
      print("Lỗi khi xử lý deep link: $err");
    });
  }

  void _handleDeepLink(Uri uri) {
    if (uri.host == "com.example.movie_app" && uri.path == "/reset-password") {
      final token = uri.queryParameters['token'];
      if (token != null) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => ResetPasswordScreen(token: token),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey, // Gắn GlobalKey vào MaterialApp
      home: widget.skipLogin ? MainPage() : SignInPage(),
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
      const MyTicketsPageCl(),
      const BlogCl(),
      const ProfilePageCl()
    ];
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await loadUser(context);
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
              icon: Icon(Icons.confirmation_number),
              label: 'Vé của tôi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.newspaper),
              label: 'News',
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

class MyTicketsPageCl extends StatelessWidget {
  const MyTicketsPageCl({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(child: MyTicketsPage());
  }
}

class BlogCl extends StatelessWidget {
  const BlogCl({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasePage(child: BlogPage());
  }
}

class ProfilePageCl extends StatelessWidget {
  const ProfilePageCl({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasePage(child: ProfilePage());
  }
}
