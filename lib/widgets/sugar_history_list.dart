import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 1. إضافة الاستيراد
import '../models/sugar_reading_model.dart';
import 'package:blood_sugar_app_1/widgets/sugar_item_history.dart';

class SugarHistoryList extends StatefulWidget {
  final List<SugarReading> readings;

  final double minTarget;
  final double maxTarget;

  const SugarHistoryList({
    super.key,
    required this.readings,
    this.minTarget = 70,
    this.maxTarget = 140,
  });

  @override
  State<SugarHistoryList> createState() => _SugarHistoryListState();
}

class _SugarHistoryListState extends State<SugarHistoryList> {
  late double minTarget;
  late double maxTarget;

  @override
  void initState() {
    super.initState();
    // إعطاء قيم أولية من الـ widget
    minTarget = widget.minTarget;
    maxTarget = widget.maxTarget;
    // 2. استدعاء التحميل فور بدء التشغيل
    _loadTargets();
  }

  Future<void> _loadTargets() async {
    final prefs = await SharedPreferences.getInstance();
    // 4. التأكد أن الـ Widget لا يزال موجوداً قبل setState
    if (!mounted) return;

    setState(() {
      minTarget = prefs.getDouble('minTarget') ?? widget.minTarget;
      maxTarget = prefs.getDouble('maxTarget') ?? widget.maxTarget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: widget.readings.length,
      itemBuilder: (context, index) {
        final r = widget.readings[widget.readings.length - 1 - index];

        return SugarHistoryItem(
          reading: r,
          // 3. استخدام القيم المحلية (المحملة من الذاكرة) وليس القادمة من الخارج
          minTarget: minTarget,
          maxTarget: maxTarget,
        );
      },
    );
  }
}
