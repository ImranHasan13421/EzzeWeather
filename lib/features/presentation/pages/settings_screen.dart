import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/settings/settings_cubit.dart';
import '../../../../core/settings/settings_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark 
              ? [const Color(0xFF0F172A), const Color(0xFF1E293B)] 
              : [const Color(0xFF8EC5FC), const Color(0xFFE0C3FC)],
          ),
        ),
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            final cubit = context.read<SettingsCubit>();
            
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildSectionHeader('Appearance'),
                _buildGlassCard(
                  context,
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.brightness_6),
                        title: const Text('Theme'),
                        trailing: DropdownButton<ThemeMode>(
                          value: state.themeMode,
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                            DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                            DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
                          ],
                          onChanged: (mode) {
                            if (mode != null) cubit.toggleTheme(mode);
                          },
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1),
                
                const SizedBox(height: 24),
                
                _buildSectionHeader('Units'),
                _buildGlassCard(
                  context,
                  child: Column(
                    children: [
                      SwitchListTile(
                        secondary: const Icon(Icons.thermostat),
                        title: const Text('Use Celsius'),
                        value: state.isCelsius,
                        onChanged: (value) => cubit.toggleTemperatureUnit(value),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideX(begin: 0.1),

                const SizedBox(height: 24),
                
                _buildSectionHeader('Location'),
                _buildGlassCard(
                  context,
                  child: Column(
                    children: [
                      SwitchListTile(
                        secondary: const Icon(Icons.location_on),
                        title: const Text('Use Current Location'),
                        subtitle: const Text('Fetch weather for your exact location'),
                        value: state.isLocationEnabled,
                        onChanged: (value) => cubit.toggleLocationEnabled(value),
                      ),
                      const Divider(height: 1, indent: 20, endIndent: 20),
                      ListTile(
                        leading: const Icon(Icons.location_city),
                        title: const Text('Default Location'),
                        subtitle: Text(state.defaultLocation),
                        onTap: () {
                          _showLocationDialog(context, state.defaultLocation, cubit);
                        },
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideX(begin: 0.1),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildGlassCard(BuildContext context, {required Widget child}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.black.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: child,
      ),
    );
  }

  void _showLocationDialog(BuildContext context, String currentLocation, SettingsCubit cubit) {
    final controller = TextEditingController(text: currentLocation);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set Default Location'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter city name'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  cubit.changeDefaultLocation(controller.text.trim());
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
