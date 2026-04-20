import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dohamaid/core/config/app_color.dart';

class AppTheme {
  // Base colors
  static const primaryColor = AppColor.indigo;
  static const lightBackground = AppColor.white;
  static const darkBackground = AppColor.darkBackground;

  // Text colors
  static const lightTextColor = AppColor.black87;
  static const darkTextColor = AppColor.white70;

  // Custom brand color (your color)
  static const brandColor = AppColor.mainColor;

  // 🌟 Custom state colors
  static const selectedColorLight = AppColor.selectedLight;
  static const unselectedColorLight = AppColor.grey;

  static const selectedColorDark = AppColor.selectedDark;
  static const unselectedColorDark = AppColor.grey;

  static ThemeData lightTheme(Locale locale) {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,
      fontFamily: locale.languageCode == 'ar' ? 'ElMessiri' : 'NotoSans',
      appBarTheme: const AppBarTheme(
        backgroundColor: brandColor,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: brandColor,
          systemNavigationBarColor: brandColor,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: primaryColor,
        brightness: Brightness.light,
      ).copyWith(
        surface: lightBackground,
        primary: selectedColorLight,
        secondary: brandColor,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: lightTextColor),
        bodyMedium: TextStyle(color: lightTextColor),
      ),
      iconTheme: const IconThemeData(color: brandColor),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: selectedColorLight,
        unselectedItemColor: unselectedColorLight,
        backgroundColor: lightBackground,
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: selectedColorLight,
        unselectedLabelColor: unselectedColorLight,
        indicatorColor: selectedColorLight,
      ),
    );
  }

  static ThemeData darkTheme(Locale locale) {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      fontFamily: locale.languageCode == 'ar' ? 'ElMessiri' : 'NotoSans',
      appBarTheme: const AppBarTheme(
        backgroundColor: brandColor,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: brandColor,
          systemNavigationBarColor: brandColor,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: primaryColor,
        brightness: Brightness.dark,
      ).copyWith(
        surface: darkBackground,
        primary: selectedColorDark,
        secondary: brandColor,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: darkTextColor),
        bodyMedium: TextStyle(color: darkTextColor),
      ),
      iconTheme: const IconThemeData(color: brandColor),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: selectedColorDark,
        unselectedItemColor: unselectedColorDark,
        backgroundColor: darkBackground,
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: selectedColorDark,
        unselectedLabelColor: unselectedColorDark,
        indicatorColor: selectedColorDark,
      ),
    );
  }
}
