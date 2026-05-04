import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WeatherIcon extends StatelessWidget {
  final int conditionCode;
  final double size;
  final Color? color;

  const WeatherIcon({
    super.key,
    required this.conditionCode,
    this.size = 50.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color iconColor = color ?? Colors.blueAccent;
    
    // Map code to material icons
    if (conditionCode == 0) {
      iconData = Icons.wb_sunny_rounded;
      iconColor = color ?? Colors.orange;
    } else if (conditionCode == 1 || conditionCode == 2 || conditionCode == 3) {
      iconData = Icons.cloud_rounded;
      iconColor = color ?? Colors.grey.shade400;
    } else if (conditionCode >= 50 && conditionCode <= 69) {
      iconData = Icons.grain_rounded; // Rain
      iconColor = color ?? Colors.blue;
    } else if (conditionCode >= 70 && conditionCode <= 79) {
      iconData = Icons.ac_unit_rounded; // Snow
      iconColor = color ?? Colors.lightBlue.shade200;
    } else if (conditionCode >= 80 && conditionCode <= 82) {
      iconData = Icons.water_drop_rounded; // Showers
      iconColor = color ?? Colors.blueAccent;
    } else if (conditionCode >= 85 && conditionCode <= 86) {
      iconData = Icons.ac_unit_rounded; // Snow showers
      iconColor = color ?? Colors.lightBlue.shade300;
    } else if (conditionCode >= 95 && conditionCode <= 99) {
      iconData = Icons.thunderstorm_rounded; // Storm
      iconColor = color ?? Colors.deepPurple;
    } else {
      iconData = Icons.cloud_rounded; // Default
    }

    return Icon(
      iconData,
      size: size,
      color: iconColor,
    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
     .moveY(begin: -5, end: 5, duration: 2.seconds, curve: Curves.easeInOut);
  }
}
