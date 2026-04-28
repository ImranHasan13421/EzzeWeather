import 'package:equatable/equatable.dart';

// Equatable allows us to compare objects easily (useful for BLoC)
class Weather extends Equatable {
  final String cityName;
  final String mainCondition;
  final double temperature;
  final int conditionCode;

  const Weather({
    required this.cityName,
    required this.mainCondition,
    required this.temperature,
    required this.conditionCode,
  });

  @override
  List<Object?> get props => [cityName, mainCondition, temperature, conditionCode];
}