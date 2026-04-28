import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;
import 'features/presentation/bloc/weather_bloc.dart';
import 'features/presentation/pages/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  di.init();

  runApp(const EzzeWeatherApp());
}

class EzzeWeatherApp extends StatelessWidget {
  const EzzeWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EzzeWeather',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // Provide the WeatherBloc to the widget tree
      home: BlocProvider(
        create: (_) => di.sl<WeatherBloc>(),
        child: const HomeScreen(),
      ),
    );
  }
}