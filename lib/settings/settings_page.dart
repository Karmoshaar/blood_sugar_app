import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _showMaxSugarDialog() {
    double tempValue = maxTarget;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Maximum Blood Sugar'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${tempValue.toInt()} mg/dL',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Slider(
                    min: 100,
                    max: 300,
                    divisions: 200,
                    value: tempValue,
                    onChanged: (value) {
                      setDialogState(() {
                        tempValue = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setDouble('maxTarget', tempValue);

                    setState(() {
                      maxTarget = tempValue;
                    });

                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showMinSugarDialog() {
    double tempValue = minTarget;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Minimum Blood Sugar'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${tempValue.toInt()} mg/dL',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Slider(
                    min: 50,
                    max: 150,
                    divisions: 100,
                    value: tempValue,
                    onChanged: (value) {
                      setDialogState(() {
                        tempValue = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setDouble('minTarget', tempValue);

                    setState(() {
                      minTarget = tempValue;
                    });

                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
  void _showTargetDialog({
    required String title,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        double tempValue = value;

        return AlertDialog(
          title: Text(title),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tempValue.toInt().toString(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Slider(
                    value: tempValue,
                    min: 50,
                    max: 250,
                    divisions: 200,
                    label: tempValue.toInt().toString(),
                    onChanged: (v) {
                      setState(() => tempValue = v);
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                onChanged(tempValue);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }


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
            subtitle: '${minTarget.toInt()} mg/dL',
            onTap: () {
              _showTargetDialog(
                title: 'Minimum Sugar',
                value: minTarget,
                onChanged: (v) async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setDouble('minTarget', v);
                  setState(() => minTarget = v);
                },
              );
            },
          ),


          _settingsTile(
            icon: Icons.trending_up,
            title: 'Maximum Sugar',
            subtitle: '${maxTarget.toInt()} mg/dL',
            onTap: () {
              _showTargetDialog(
                title: 'Maximum Sugar',
                value: maxTarget,
                onChanged: (v) async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setDouble('maxTarget', v);
                  setState(() => maxTarget = v);
                },
              );
            },
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
