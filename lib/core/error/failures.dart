import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

// Represents a failure when communicating with the external API
class ServerFailure extends Failure {}

// You can add more here later, like CacheFailure for offline mode