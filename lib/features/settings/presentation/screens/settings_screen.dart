import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../profile/presentation/providers/profile_controller.dart';
import '../providers/settings_controller.dart';
import '../widgets/settings_dialogs.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final settings = ref.watch(settingsProvider);
    final profileController = ref.read(profileProvider.notifier);
    final settingsController = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (profile != null) ...[
            _sectionTitle('Profile'),
            _settingsTile(
              icon: Icons.person,
              title: 'Name',
              subtitle: profile.name,
              onTap: () async {
                final result = await SettingsDialogs.text(
                  context: context,
                  title: 'Your Name',
                  initialValue: profile.name,
                  hint: 'Enter your name',
                );
                if (result != null) {
                  await profileController.update(
                    (p) => p.copyWith(name: result),
                  );
                }
              },
            ),
            _settingsTile(
              icon: Icons.cake,
              title: 'Age',
              subtitle: '${profile.age} years',
              onTap: () async {
                final now = DateTime.now();
                final result = await showDatePicker(
                  context: context,
                  initialDate: profile.birthDate,
                  firstDate: DateTime(1900),
                  lastDate: now,
                  helpText: 'Birth date',
                );
                if (result != null) {
                  await profileController.update(
                    (p) => p.copyWith(birthDate: result),
                  );
                }
              },
            ),
            _settingsTile(
              icon: Icons.monitor_weight,
              title: 'Weight',
              subtitle: '${profile.weightKg.round()} kg',
              onTap: () async {
                final result = await SettingsDialogs.number(
                  context: context,
                  title: 'Weight (kg)',
                  initialValue: profile.weightKg.round(),
                  min: 30,
                  max: 200,
                );
                if (result != null) {
                  await profileController.update(
                    (p) => p.copyWith(weightKg: result.toDouble()),
                  );
                }
              },
            ),
            _settingsTile(
              icon: Icons.height,
              title: 'Height',
              subtitle: '${profile.heightCm.round()} cm',
              onTap: () async {
                final result = await SettingsDialogs.number(
                  context: context,
                  title: 'Height (cm)',
                  initialValue: profile.heightCm.round(),
                  min: 100,
                  max: 220,
                );
                if (result != null) {
                  await profileController.update(
                    (p) => p.copyWith(heightCm: result.toDouble()),
                  );
                }
              },
            ),
            const SizedBox(height: 24),
          ],

          _sectionTitle('Health Goals'),
          _settingsTile(
            icon: Icons.trending_down,
            title: 'Minimum Sugar',
            subtitle: '${settings.minTarget} mg/dL',
            onTap: () async {
              final result = await SettingsDialogs.target(
                context: context,
                title: 'Minimum Sugar',
                initialValue: settings.minTarget,
                min: 50,
                // Keep the range valid: min must stay below max.
                max: settings.maxTarget - 1,
              );
              if (result != null) await settingsController.setMinTarget(result);
            },
          ),
          _settingsTile(
            icon: Icons.trending_up,
            title: 'Maximum Sugar',
            subtitle: '${settings.maxTarget} mg/dL',
            onTap: () async {
              final result = await SettingsDialogs.target(
                context: context,
                title: 'Maximum Sugar',
                initialValue: settings.maxTarget,
                min: settings.minTarget + 1,
                max: 300,
              );
              if (result != null) await settingsController.setMaxTarget(result);
            },
          ),

          const SizedBox(height: 24),

          _sectionTitle('Notifications'),
          _settingsTile(
            icon: Icons.alarm,
            title: 'Reminder Time',
            subtitle: settings.reminderTime?.format(context) ?? 'Not set',
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: settings.reminderTime ?? TimeOfDay.now(),
              );
              if (picked != null) {
                await settingsController.setReminderTime(picked);
              }
            },
          ),

          const SizedBox(height: 24),

          _sectionTitle('Preferences'),
          _settingsTile(
            icon: Icons.straighten,
            title: 'Units',
            subtitle: settings.unit.label,
            onTap: () async {
              final result = await SettingsDialogs.unit(context, settings.unit);
              if (result != null) await settingsController.setUnit(result);
            },
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
