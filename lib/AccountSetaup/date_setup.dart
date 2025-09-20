import 'package:flutter/material.dart';
import 'name_setup.dart';
import 'package:dss_cupertino_date_picker/dss_cupertino_date_picker.dart';
import 'weight_setup.dart';

class DateSetup extends StatefulWidget {
  const DateSetup({super.key});

  @override
  State<DateSetup> createState() => _DateSetupState();
}

class _DateSetupState extends State<DateSetup> {
  DateTime _selectedDate = DateTime.now();
  final DateTime _minDate = DateTime(1900, 1, 1);
  final DateTime _maxDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: 0.5,
                  color: const Color.fromARGB(255, 251, 68, 82),
                  backgroundColor: Colors.grey,
                  minHeight: 12,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 16),
              const Text('3/6'),
            ],
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 40),
          const Text(
            'When is your birthday?',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          SizedBox(
            height: 550,
            child: CupertinoDatePicker(
              itemExtent: 50,
              minDate: _minDate,
              maxDate: _maxDate,
              selectedDate: _selectedDate,
              selectionOverlay: Container(
                width: double.infinity,
                height: 50,
                decoration: const BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(color: Color.fromARGB(255, 251, 68, 82), width: 1),
                  ),
                ),
              ),
              selectedStyle: const TextStyle(
                color: Color.fromARGB(255, 251, 68, 82),
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
              unselectedStyle: TextStyle(color:Colors.black, fontSize: 18),
              disabledStyle: TextStyle(color: Color.fromARGB(255, 251, 68, 82), fontSize: 18),
              onSelectedItemChanged: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),
          ),

          const Spacer(),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WeightSetup()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 251, 68, 82),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 80),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
            ),
            child: const Text(
              "continue",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
