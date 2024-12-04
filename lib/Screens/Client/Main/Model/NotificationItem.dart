import 'package:flutter/material.dart';

class NotificationItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final DateTime time;

  NotificationItem(
      {required this.icon,
      required this.iconColor,
      required this.title,
      required this.time});
}
