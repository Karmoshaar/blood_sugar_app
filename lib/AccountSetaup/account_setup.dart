import 'package:flutter/material.dart';
import 'package:blood_sugar_app_1/AccountSetaup/name_setup.dart';
class AccountSetup extends StatelessWidget {
  const AccountSetup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 100),
            Image.asset(
              'asset/image/logoHeart.png',
              width: 150,
              height: 150,
              errorBuilder: (context, error, stackTrace) {
                return const Text('Failed to load image');
              },
            ),
            Text(
              'Welcome to Pulsey! 👋🏻',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Text(
              'Before we begin, please provide us with some '
              'personal information to ensure accurate '
              'monitoring',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 400),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => NameSetup()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 251, 68, 82),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "ok,let's start",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
