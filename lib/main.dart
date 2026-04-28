import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const EzzeWeatherApp());
}

class EzzeWeatherApp extends StatelessWidget {
  const EzzeWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EzzeWeather',
      debugShowCheckedModeBanner: false, // Hides the debug banner
      theme: ThemeData(
        fontFamily: 'Roboto', // You can change this later
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}