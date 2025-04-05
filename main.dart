// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import 'cur.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the debug banner
      title: 'Currency Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Custom primary color
        scaffoldBackgroundColor: Colors.white, // Background color for app
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontFamily: 'Roboto', // Optional: Set a default font
          ),
        ),
      ),
      home: const CurrencyConverterMaterialPage(), // Your main page
    );
  }
}
