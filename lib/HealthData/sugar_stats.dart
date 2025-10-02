import 'package:flutter/material.dart';

Widget _buildStat(String value, String label) {
  return Column(
    children: [
      Text(
        value,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 4),
      Text(label, style: TextStyle(color: Colors.grey[600])),
    ],
  );
}

int _selected = 1; // 1 = Statistics (Bar), 2 = History (Line)

class SugarStats extends StatefulWidget {
  const SugarStats({super.key});

  @override
  _SugarStatsState createState() => _SugarStatsState();
}

class _SugarStatsState extends State<SugarStats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Card(
                margin: const EdgeInsets.all(16),
                elevation: 9,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Blood Sugar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Lifetime summary",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStat("90.6", "Average"),
                          _buildStat("132.5", "Maximum"),
                          _buildStat("74.9", "Minimum"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -2,
                right: -5,
                child: Image.asset(
                  "asset/image/bubble.png",
                  width: 100,
                  height: 100,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // زر Statistics
                _selected == 1
                    ? ElevatedButton(
                        onPressed: () => setState(() => _selected = 1),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 251, 68, 82),
                          foregroundColor: Colors.white,
                          minimumSize: Size(140, 40),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text("Statistics"),
                      )
                    : OutlinedButton(
                        onPressed: () => setState(() => _selected = 1),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: BorderSide(color: Colors.grey.shade300),
                          minimumSize: Size(140, 40),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Statistics"),
                      ),

                const SizedBox(width: 10),

                // زر History
                _selected == 2
                    ? ElevatedButton(
                        onPressed: () => setState(() => _selected = 2),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 251, 68, 82),
                          foregroundColor: Colors.white,
                          minimumSize: Size(140, 40),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text("History"),
                      )
                    : OutlinedButton(
                        onPressed: () => setState(() => _selected = 2),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          minimumSize: Size(140, 40),
                          side: BorderSide(color: Colors.grey.shade300),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("History"),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
