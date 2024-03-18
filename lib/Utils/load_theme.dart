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
    return ThemeData(
      primaryColor: kPrimaryColor,
      scaffoldBackgroundColor: Colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: kPrimaryColor,
          shape: const StadiumBorder(),
          maximumSize: const Size(double.infinity, 56),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: kPrimaryLightColor,
        iconColor: kPrimaryColor,
        prefixIconColor: kPrimaryColor,
        contentPadding: EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

/*

How is this used?

@override
Widget build(BuildContext context) {
  return FutureBuilder<ThemeData>(
    future: loadTheme(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error loading theme: ${snapshot.error}');
      } else {
        final theme = snapshot.data!;
        return Theme(
          data: theme,
          child: Scaffold(
            appBar: AppBar(), // your app bar
            body: Container(), //your body
          ),
        );
      }
    },
  );
}

*/