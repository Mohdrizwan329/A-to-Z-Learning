// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'dart:async';
// import 'package:learning_a_to_z/view/home/home_page.dart';
// import 'package:learning_a_to_z/view/bottom%20bar/bottom_navigate_bar.dart';
// import 'package:learning_a_to_z/view/login/LoginPage.dart';

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   // final auth = FirebaseAuth.instance;
//   // late final user = auth.currentUser;
//   void userCheck() {
//     if (user != Null) {
//       Timer(Duration(seconds: 3), () {
//         Get.to(BottomNavigatBarScreen());
//       });
//     } else {
//       Timer(Duration(seconds: 3), () {
//         Get.to(HomeScreen());
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     userCheck();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           Image.asset('assets/Splash Screen.png', fit: BoxFit.fill),
//           Center(child: CircularProgressIndicator(color: Colors.black)),
//         ],
//       ),
//     );
//   }
// }
