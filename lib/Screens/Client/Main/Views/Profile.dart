import 'package:flutter/material.dart';
import 'package:movie_app/Screens/Client/Authentication/Views/SignInPage.dart';
import 'package:movie_app/Screens/Client/Main/Views/Profile/FavoriteMovie.dart';
import 'package:movie_app/Screens/Client/Main/Views/Profile/InfoProfile.dart';
import 'package:movie_app/Screens/Client/Main/Views/Profile/Notification.dart';
import 'package:movie_app/Themes/app_theme.dart';
import 'package:movie_app/manager/UserProvider.dart';
import 'package:movie_app/models/user.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      backgroundColor:
          _isDarkMode ? AppTheme.colors.mainBackground : AppTheme.colors.white,
      body: _page(user),
    );
  }

  Widget _page(User? user) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            child: Column(
              children: [
                _headerPage(user),
                const SizedBox(height: 30),
                _mainPage()
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _headerPage(User? user) {
    return user == null
        ? Center(
            child: Text(
              "Không có thông tin người dùng!",
              style: TextStyle(color: AppTheme.colors.white, fontSize: 18),
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Profile',
                style: TextStyle(
                  color: AppTheme.colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        AssetImage('assets/images/User/avatar.jpg'),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullname ?? "Anonymous User",
                        style: TextStyle(
                          color: AppTheme.colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            color: AppTheme.colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            user.phone ?? "+123 456 789",
                            style: TextStyle(
                              color: AppTheme.colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.email,
                            color: AppTheme.colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            user.email ?? "anonymous-user@exemple.com",
                            style: TextStyle(
                              color: AppTheme.colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
              ),
              const SizedBox(height: 20),
            ],
          );
  }

  Widget _mainPage() {
    return Column(
      children: [
        _buildListTile(
          icon: Icons.person,
          title: 'Personal Info',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const InfoPage()),
            );
          },
        ),
        _buildListTile(
          icon: Icons.notifications,
          title: 'Notification',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationPage()),
            );
          },
        ),
        _buildListTile(
          icon: Icons.movie,
          title: 'Favorite Movie',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const FavoriteMoviePage()),
            );
          },
        ),
        _buildListTile(
          icon: Icons.security,
          title: 'Security',
          onTap: () {},
        ),
        _buildDarkModeTile(),
        const SizedBox(height: 20),
        _buildLogoutTile(),
      ],
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppTheme.colors.pink,
      ),
      title: Text(
        title,
        style: TextStyle(
            color: AppTheme.colors.white,
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: AppTheme.colors.white,
        size: 18,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDarkModeTile() {
    return ListTile(
      leading: Icon(
        Icons.dark_mode,
        color: _isDarkMode ? AppTheme.colors.pink : AppTheme.colors.black,
      ),
      title: Text(
        'Dark Mode',
        style: TextStyle(
          color: _isDarkMode ? AppTheme.colors.white : AppTheme.colors.black,
          fontSize: 18,
        ),
      ),
      trailing: Switch(
        value: _isDarkMode,
        onChanged: (bool value) {
          setState(() {
            _isDarkMode = value;
          });
        },
        activeColor: AppTheme.colors.blue,
      ),
    );
  }

  Widget _buildLogoutTile() {
    return ListTile(
      leading: Icon(
        Icons.exit_to_app,
        color: AppTheme.colors.buttonColor,
      ),
      title: Text(
        'Logout',
        style: TextStyle(
          color: AppTheme.colors.buttonColor,
          fontSize: 18,
        ),
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppTheme.colors.buttonColor, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      onTap: () async {
        // await logout();
        // Xóa thông tin lưu trong SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        // Xóa thông tin trong UserProvider
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.clearUser();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
        );
      },
    );
  }
}
