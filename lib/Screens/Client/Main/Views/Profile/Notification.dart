import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/Screens/Client/Main/Model/NotificationItem.dart';
import 'package:movie_app/Themes/app_theme.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int calculateDaysDifference(DateTime dateFromDatabase) {
    DateTime currentDate = DateTime.now();
    return currentDate.difference(dateFromDatabase).inDays;
  }

  @override
  void initState() {
    super.initState();

    // Test hàm calculateDaysDifference
    DateTime now = DateTime.now();
    DateTime pastDate = DateTime.parse("2024-11-09");

    int difference = calculateDaysDifference(pastDate);
    print(pastDate);
    print("Số ngày cách nhau: $difference");
  }

  final List<NotificationItem> notifications = [
    NotificationItem(
      icon: Icons.local_offer,
      iconColor: Colors.red,
      title: "50% Off Extravaganza: Grab Your Movie Tickets at Half the Price!",
      time: DateTime.now().subtract(Duration(hours: 2)),
    ),
    NotificationItem(
      icon: Icons.movie,
      iconColor: Colors.green,
      title:
          "Successful purchase enjoy unforgettable Adventures with Super Mario movies",
      time: DateTime.now().subtract(Duration(days: 1)),
    ),
    NotificationItem(
      icon: Icons.warning,
      iconColor: Colors.orange,
      title: "Yo, Your account got spotted on a new device",
      time: DateTime.now().subtract(Duration(days: 3)),
    ),
  ];

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Spacer(),
        Text(
          'Notification',
          style: TextStyle(
            color: AppTheme.colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        Spacer(),
      ],
    );
  }

  Widget _mainPage() {
    DateTime now = DateTime.now();
    return Column(
      children: [
        _buildInfoMessage(),
        const SizedBox(height: 20),
        _buildSectionHeader("Today"),
        ...notifications.map((notification) {
          String sectionTitle = _getSectionTitle(notification.time, now);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (sectionTitle != "Today") _buildSectionHeader(sectionTitle),
              _buildNotificationItem(
                icon: notification.icon,
                iconColor: notification.iconColor,
                title: notification.title,
                time: DateFormat('hh:mm a').format(notification.time),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  String _getSectionTitle(DateTime notificationTime, DateTime now) {
    Duration difference = now.difference(notificationTime);
    if (difference.inDays == 0) {
      return "Today";
    } else if (difference.inDays == 1) {
      return "1 day ago";
    } else if (difference.inDays == 2) {
      return "2 day ago";
    } else {
      return "A few days ago";
    }
  }

  Widget _buildInfoMessage() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.info, color: Colors.red),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Information!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Take a few minutes to read the notice carefully to update new promotions, events and important changes when using our services!",
                  style: TextStyle(color: Colors.red.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'Poppins',
                color: AppTheme.colors.white),
          ),
          TextButton(
            onPressed: () {},
            child: Text("Mark all read"),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String time,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: iconColor.withOpacity(0.2),
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: AppTheme.colors.white),
      ),
      subtitle: Text(time, style: TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}
