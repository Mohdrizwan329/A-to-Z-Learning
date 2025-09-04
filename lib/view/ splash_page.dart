import 'package:flutter/material.dart';
import 'dart:async';
import 'package:learning_a_to_z/view/home/Home_Page.dart';
import 'package:learning_a_to_z/view/bottom%20bar/bottom_navigate_bar.dart';
import 'package:learning_a_to_z/view/login/LoginPage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/Splash Screen.png', fit: BoxFit.fill),
          Center(child: CircularProgressIndicator(color: Colors.black)),
        ],
      ),
    );
  }
}
