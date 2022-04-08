import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = Color(0xFF77A500);

  static ThemeData get lightTheme => ThemeData(
        fontFamily: 'GoogleSans',
        primaryColor: const Color(0xFF77A500),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFFF9F3F0),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF9F3F0),
          foregroundColor: Colors.black,
        ),
        scaffoldBackgroundColor: const Color(0xFFF9F3F0),
        textTheme: const TextTheme(),
      );
}
