// ignore: file_names
import 'package:flutter/material.dart';
import 'package:movie_app/Themes/app_theme.dart';

class BasePage extends StatelessWidget {
  final Widget child;

  const BasePage({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppTheme.colors.mainBackground,
            ),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}
