import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants.dart';

Future<ThemeData> loadTheme() async {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final themeString = await _storage.read(key: 'theme');
  print('Loaded theme: $themeString');
  if (themeString == 'Oscuro') {
    return ThemeData(
      scaffoldBackgroundColor: const Color(0xFF1F2128),
      appBarTheme: const AppBarTheme(
        color: Color(0xFF2B2D3E),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: Typography.material2021().white.copyWith(
        bodyMedium: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        titleMedium: const TextStyle(
          fontSize: 16,
          color: Colors.green,
          fontWeight: FontWeight.w300,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(
          fontSize: 18.0,
          color: kPrimaryColor,
        ),
      ),
    );
  } else {
    return ThemeData.light();
  }
}

/*

How is this used?

@override
Widget build(BuildContext context) {
  return FutureBuilder<ThemeData>(
    future: loadTheme(), // Use the imported loadTheme function
    builder: (context, snapshot) {
      // ... (rest of the code remains the same)
    },
  );
}

*/