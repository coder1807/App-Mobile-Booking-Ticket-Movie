import "package:flutter/material.dart";
import "package:movie_app/Themes/colors.dart";

@immutable
class AppTheme {
  static const colors = AppColors();
  const AppTheme._();
  static ThemeData define() {
    return ThemeData(fontFamily: 'Poppins');
  }
}
