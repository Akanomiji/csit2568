import 'package:flutter/material.dart';
import 'package:csit2568/loginpage.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('images/csitlogo.png', width: 400, height: 400),

            SizedBox(height: 10.0),

            Text(
              'Welcome !! CSIT Family',
              style: TextStyle(
                fontSize: 30,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10.0),

            SizedBox(
              child: OutlinedButton(
                onPressed: () {
                  // เมื่อปุ่มถูกคลิก
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  fixedSize: Size(300, 50),
                  side: BorderSide(
                    color: Color.fromARGB(255, 164, 128, 225),
                    width: 2.0,
                  ),
                  backgroundColor: Color.fromARGB(255, 164, 128, 225),
                ),
                child: Text(
                  'เริ่มใช้งาน',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
