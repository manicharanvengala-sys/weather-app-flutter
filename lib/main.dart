import 'package:flutter/material.dart';
import 'package:weather_y18/pages/weather_details.dart';
import 'package:weather_y18/pages/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      home: Home()
    );
  }
}