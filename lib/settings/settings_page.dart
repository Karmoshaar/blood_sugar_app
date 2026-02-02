import 'package:blood_sugar_app_1/core/ui/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/settings_dialogs.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String userName = 'Guest';
  double minTarget = 70;
  double maxTarget = 140;
  int age = 22;
  TimeOfDay? reminderTime;
  double weight = 70;
  String units = 'mg/dL';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      minTarget = prefs.getDouble('minTarget') ?? 70;
      maxTarget = prefs.getDouble('maxTarget') ?? 140;
      userName = prefs.getString('userName') ?? 'Guest';
      weight = prefs.getDouble('weight') ?? 70;
      units = prefs.getString('units') ?? 'mg/dL';
      final hour = prefs.getInt('reminderHour');
      final minute = prefs.getInt('reminderMinute');
      if (hour != null && minute != null) {
        reminderTime = TimeOfDay(hour: hour, minute: minute);
      }
    });
  }

  Future<void> _pickReminderTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: reminderTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('reminderHour', picked.hour);
      await prefs.setInt('reminderMinute', picked.minute);

      setState(() => reminderTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle('Profile'),
          _settingsTile(
            icon: Icons.person,
            title: 'Name',
            subtitle: userName,
            onTap: () async {
              final result = await showNameDialog(context, userName);
              if (result != null) {
                setState(() => userName = result);
              }
            },
          ),

          _settingsTile(
            icon: Icons.cake,
            title: 'Age',
            subtitle: '$age years',
            onTap: () async {
              final result = await AppDialogs.numberInput(
                context: context,
                title: "Age",
                initialValue: 25,
                min: 1,
                max: 120,
              );

              if (result != null) {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setInt('age', result);
                setState(() => age = result);
              }
            },
          ),

          _settingsTile(
            icon: Icons.monitor_weight,
            title: 'Weight',
            subtitle: '${weight.toInt()} kg',
            onTap: () async {
              final result = await AppDialogs.weight(context, weight);
              if (result != null) {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setDouble('weight', result);
                setState(() => weight = result);
              }
            },
          ),

          const SizedBox(height: 24),

          _sectionTitle('Health Goals'),
          _settingsTile(
            icon: Icons.trending_down,
            title: 'Minimum Sugar',
            subtitle: '${minTarget.toInt()} mg/dL',
            onTap: () async {
              final result = await AppDialogs.target(
                context: context,
                title: 'Minimum Sugar',
                initialValue: minTarget,
                min: 50,
                max: 150,
              );

              if (result != null) {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setDouble('minTarget', result);

                setState(() => minTarget = result);
              }
            },
          ),

          _settingsTile(
            icon: Icons.trending_up,
            title: 'Maximum Sugar',
            subtitle: '${maxTarget.toInt()} mg/dL',
            onTap: () async {
              final result = await AppDialogs.target(
                context: context,
                title: 'Maximum Sugar',
                initialValue: maxTarget,
                min: 100,
                max: 300,
              );

              if (result != null) {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setDouble('maxTarget', result);

                setState(() => maxTarget = result);
              }
            },
          ),

          const SizedBox(height: 24),

          _sectionTitle('Notifications'),
          _settingsTile(
            icon: Icons.alarm,
            title: 'Reminder Time',
            subtitle: reminderTime == null
                ? 'Not set'
                : reminderTime!.format(context),
            onTap: _pickReminderTime,
          ),

          const SizedBox(height: 24),

          _sectionTitle('Preferences'),
          _settingsTile(
            icon: Icons.straighten,
            title: 'Units',
            subtitle: units,
            onTap: () async {
              final result = await AppDialogs.units(context, units);
              if (result != null) {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('units', result);
                setState(() => units = result);
              }
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
