import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferences sharedPreferences;

  static const String _themeKey = 'theme_mode';
  static const String _tempUnitKey = 'temp_unit_celsius';
  static const String _locationEnabledKey = 'location_enabled';
  static const String _defaultLocationKey = 'default_location';

  SettingsCubit({required this.sharedPreferences}) : super(const SettingsState()) {
    _loadSettings();
  }

  void _loadSettings() {
    final themeIndex = sharedPreferences.getInt(_themeKey);
    final themeMode = themeIndex != null ? ThemeMode.values[themeIndex] : ThemeMode.system;
    
    final isCelsius = sharedPreferences.getBool(_tempUnitKey) ?? true;
    final isLocationEnabled = sharedPreferences.getBool(_locationEnabledKey) ?? true;
    final defaultLocation = sharedPreferences.getString(_defaultLocationKey) ?? 'London';

    emit(SettingsState(
      themeMode: themeMode,
      isCelsius: isCelsius,
      isLocationEnabled: isLocationEnabled,
      defaultLocation: defaultLocation,
    ));
  }

  Future<void> toggleTheme(ThemeMode themeMode) async {
    await sharedPreferences.setInt(_themeKey, themeMode.index);
    emit(state.copyWith(themeMode: themeMode));
  }

  Future<void> toggleTemperatureUnit(bool isCelsius) async {
    await sharedPreferences.setBool(_tempUnitKey, isCelsius);
    emit(state.copyWith(isCelsius: isCelsius));
  }

  Future<void> toggleLocationEnabled(bool isEnabled) async {
    await sharedPreferences.setBool(_locationEnabledKey, isEnabled);
    emit(state.copyWith(isLocationEnabled: isEnabled));
  }

  Future<void> changeDefaultLocation(String location) async {
    await sharedPreferences.setString(_defaultLocationKey, location);
    emit(state.copyWith(defaultLocation: location));
  }
}
