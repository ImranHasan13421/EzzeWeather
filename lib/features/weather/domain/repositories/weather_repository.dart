import 'package:dartz/dartz.dart'; // Helps handle errors elegantly
import '../../../../core/error/failures.dart';
import '../entities/weather.dart';

abstract class WeatherRepository {
  // Either returns a Failure (Left) or Weather data (Right)
  Future<Either<Failure, Weather>> getCurrentWeather(String city);
}