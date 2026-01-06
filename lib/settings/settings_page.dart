import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double minTarget = 70;
  double maxTarget = 140;
  @override
  void initState(){
    super.initState();
    _loadSettings();
  }
  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      minTarget = prefs.getDouble('minTarget') ?? 70;
      maxTarget = prefs.getDouble('maxTarget') ?? 140;
    });
  }


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
            subtitle: 'Edit your name',
          ),
          _settingsTile(
            icon: Icons.cake,
            title: 'Age',
            subtitle: 'Edit your age',
          ),
          _settingsTile(
            icon: Icons.monitor_weight,
            title: 'Weight',
            subtitle: 'Edit your weight',
          ),

          const SizedBox(height: 24),

          _sectionTitle('Health Goals'),
          _settingsTile(
            icon: Icons.trending_down,
            title: 'Minimum Sugar',
            subtitle: 'Set minimum target',
          ),
          _settingsTile(
            icon: Icons.trending_up,
            title: 'Maximum Sugar',
            subtitle: 'Set maximum target',
          ),

          const SizedBox(height: 24),

          _sectionTitle('Notifications'),
          _settingsTile(
            icon: Icons.alarm,
            title: 'Reminder Time',
            subtitle: 'Daily reminder',
          ),

          const SizedBox(height: 24),

          _sectionTitle('Preferences'),
          _settingsTile(
            icon: Icons.straighten,
            title: 'Units',
            subtitle: 'mg/dL',
          ),
          _settingsTile(
            icon: Icons.dark_mode,
            title: 'Theme',
            subtitle: 'Light / Dark',
          ),
        ],
      ),
    );
  }

  // عنوان القسم
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
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}
