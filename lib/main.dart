import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/settings/settings_cubit.dart';
import 'core/settings/settings_state.dart';
import 'injection_container.dart' as di;
import 'features/presentation/bloc/weather_bloc.dart';
import 'features/presentation/pages/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.init();

  runApp(const EzzeWeatherApp());
}

class EzzeWeatherApp extends StatelessWidget {
  const EzzeWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<SettingsCubit>()),
        BlocProvider(create: (_) => di.sl<WeatherBloc>()),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          return MaterialApp(
            title: 'EzzeWeather',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsState.themeMode,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}