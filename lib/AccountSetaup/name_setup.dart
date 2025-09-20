import 'package:flutter/material.dart';
import 'Gender_Setup.dart';

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
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: 0.16,
                  color: Color.fromARGB(255, 251, 68, 82),
                  backgroundColor: Colors.grey,
                  minHeight: 12,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(width: 16),
              Text('1/6'),
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 50),
          Text(
            'What is your name?',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 250),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your name',
              ),
            ),
          ),
          SizedBox(height: 400),
          ElevatedButton(
            onPressed: (
                ) {
            Navigator.push (context,MaterialPageRoute(builder: (_) => GenderSetup()) );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 251, 68, 82),
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 80),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
            ),
            child: Text(
              "continue",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
