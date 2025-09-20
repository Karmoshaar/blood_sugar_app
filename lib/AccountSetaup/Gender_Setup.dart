import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'name_setup.dart';
import 'date_setup.dart';

class GenderSetup extends StatefulWidget {
  const GenderSetup({super.key});

  @override
  State<GenderSetup> createState() => _GenderSetupState();
}

class _GenderSetupState extends State<GenderSetup> {
  bool agree = false;
  String? selectedGender;

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
                  value: 0.32,
                  color: Color.fromARGB(255, 251, 68, 82),
                  backgroundColor: Colors.grey,
                  minHeight: 12,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(width: 16),
              Text('2/6'),
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
            'What is your gender?',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 250),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // أيقونة ذكر
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedGender = "male";
                  });
                },
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: selectedGender == "male"
                      ? Color.fromARGB(255, 251, 68, 82)
                      : Colors.grey[300],
                  child: FaIcon(
                    FontAwesomeIcons.mars,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              SizedBox(width: 30),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedGender = "female";
                  });
                },
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: selectedGender == "female"
                      ? Color.fromARGB(255, 251, 68, 82)
                      : Colors.grey[300],
                  child: FaIcon(
                    FontAwesomeIcons.venus,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ],
          ),


          SizedBox(height: 350),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DateSetup()),
              );
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
