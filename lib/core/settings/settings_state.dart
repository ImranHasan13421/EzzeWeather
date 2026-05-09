import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final bool isCelsius;
  final bool isLocationEnabled;
  final String defaultLocation;

  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.isCelsius = true,
    this.isLocationEnabled = true,
    this.defaultLocation = 'London', // Default fallback
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    bool? isCelsius,
    bool? isLocationEnabled,
    String? defaultLocation,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      isCelsius: isCelsius ?? this.isCelsius,
      isLocationEnabled: isLocationEnabled ?? this.isLocationEnabled,
      defaultLocation: defaultLocation ?? this.defaultLocation,
    );
  }

  @override
  List<Object?> get props => [themeMode, isCelsius, isLocationEnabled, defaultLocation];
}
