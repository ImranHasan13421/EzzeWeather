import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/weather.dart';

abstract class WeatherRepository {
  // Either returns a Failure (Left) or Weather data (Right)
  Future<Either<Failure, Weather>> getCurrentWeather(String city);

  // Either returns a Failure (Left) or a List of city strings (Right)
  Future<Either<Failure, List<String>>> searchCities(String query);
}