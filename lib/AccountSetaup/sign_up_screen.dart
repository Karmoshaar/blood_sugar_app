import 'package:flutter/material.dart';
import 'package:blood_sugar_app_1/AccountSetaup/account_setup.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool agree = false;
  bool _obsureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Join Pulsey Today ✨",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Create your account and start monitoring your health.",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 30),

            // Email field
            TextField(
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 50),
            TextField(
              obscureText: _obsureText,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon:Icon(
                  _obsureText ? Icons.visibility : Icons.visibility_off),
                  onPressed: (){
                    setState(() {
                      _obsureText=!_obsureText;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  activeColor: Color.fromARGB(255, 251, 68, 82),
                  side: BorderSide(
                    color: Color.fromARGB(255, 251, 68, 82),
                    width: 2,
                  ),
                  value: agree,
                  onChanged: (val) {
                    setState(() {
                      agree = val!;
                    });
                  },
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: "I agree to Pulsey ",
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: "Terms & Conditions",
                          style: TextStyle(
                            color: Color.fromARGB(255, 251, 68, 82),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account? "),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => AccountSetup()),
                    );
                  },

                  child: Text(
                    "Sign in",
                    style: TextStyle(
                      color: Color.fromARGB(255, 251, 68, 82),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 60),

            // OR continue with
            Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("or continue with"),
                ),
                Expanded(child: Divider()),
              ],
            ),
            SizedBox(height: 30),

            // Social buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _socialButton(Icons.g_mobiledata, Colors.red),
                _socialButton(Icons.apple, Colors.black),
                _socialButton(Icons.facebook, Colors.blue),
                _socialButton(Icons.close, Colors.grey),
              ],
            ),
            SizedBox(height: 150),

            // Sign up button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (!agree) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("You must agree to the terms")),
                    );
                    return;
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 251, 68, 82),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialButton(IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Icon(icon, color: color, size: 28),
    );
  }
}
