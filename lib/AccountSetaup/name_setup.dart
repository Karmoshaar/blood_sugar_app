import 'package:flutter/material.dart';

class NameSetup extends StatefulWidget {
  const NameSetup({super.key});

  @override
  _NameSetupState createState() => _NameSetupState();
}

class _NameSetupState extends State<NameSetup> {
  bool agree = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: 0.3,
                  color: Color.fromARGB(255, 251, 68, 82),
                  backgroundColor: Colors.grey,
                  minHeight: 12,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
