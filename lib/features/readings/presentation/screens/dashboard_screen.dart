import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../settings/presentation/providers/settings_controller.dart';
import '../../../settings/presentation/screens/settings_screen.dart';
import '../../domain/reading_stats.dart';
import '../providers/readings_controller.dart';
import '../widgets/add_reading_dialog.dart';
import '../widgets/reading_history_list.dart';
import '../widgets/readings_charts.dart';
import '../widgets/summary_card.dart';

enum _View { bar, line, history }

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  _View _selected = _View.bar;

  @override
  Widget build(BuildContext context) {
    final readingsAsync = ref.watch(readingsProvider);
    final stats = ReadingStats(readingsAsync.value ?? const []);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Blood Sugar', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SummaryCard(stats: stats),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _toggleButton(
                    'Statistics',
                    isActive: _selected != _View.history,
                    onTap: () => setState(() => _selected = _View.bar),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _toggleButton(
                    'History',
                    isActive: _selected == _View.history,
                    onTap: () => setState(() => _selected = _View.history),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _header(),
                      const SizedBox(height: 24),
                      Expanded(
                        child: readingsAsync.when(
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (_, _) => const Center(
                            child: Text('Could not load readings'),
                          ),
                          data: (_) => stats.isEmpty
                              ? const Center(child: Text('No data available'))
                              : _content(stats),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _addButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _content(ReadingStats stats) {
    switch (_selected) {
      case _View.bar:
        return ReadingsBarChart(readings: stats.last7);
      case _View.line:
        return ReadingsLineChart(readings: stats.sortedByTime);
      case _View.history:
        final settings = ref.watch(settingsProvider);
        return ReadingHistoryList(
          readings: stats.sortedByTime,
          minTarget: settings.minTarget,
          maxTarget: settings.maxTarget,
        );
    }
  }

  Widget _toggleButton(
    String title, {
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    );
    return isActive
        ? ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              shape: shape,
            ),
            child: Text(title, style: const TextStyle(color: Colors.white)),
          )
        : OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.grey),
              shape: shape,
            ),
            child: Text(title, style: const TextStyle(color: Colors.black)),
          );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Blood sugar (mg/dL)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            _chartIcon(Icons.bar_chart, _View.bar),
            const SizedBox(width: 8),
            _chartIcon(Icons.show_chart, _View.line),
          ],
        ),
      ],
    );
  }

  Widget _chartIcon(IconData icon, _View view) {
    final selected = _selected == view;
    return GestureDetector(
      onTap: () => setState(() => _selected = view),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryDark : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: selected ? Colors.white : Colors.grey,
          size: 20,
        ),
      ),
    );
  }

  Widget _addButton() {
    return ElevatedButton(
      onPressed: () => showDialog<void>(
        context: context,
        builder: (_) => const AddReadingDialog(),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(150, 45),
      ),
      child: const Text('Add Reading'),
    );
  }
}
