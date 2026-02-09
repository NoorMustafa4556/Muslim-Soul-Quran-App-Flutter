import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_quran_yt/Constants/Constants.dart'; // Added import
import 'package:flutter_quran_yt/Screens/MainScreen.dart';
import 'package:flutter_quran_yt/Screens/OnboardingScreen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool alreadyUsed = false;

  void getData() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    alreadyUsed = prefs.getBool("alreadyUsed") ?? false;
    // onBoarding screen will show for first time
  }

  @override
  void initState() {
    super.initState();
    getData();
    // Timer(Duration(seconds: 3), ()=>Navigator.pushReplacement(context
    // MaterialPageRoute(builder: (context){
    //   return  alreadyUsed ? MainScreen() : OnBoardingScreen();
    // })
    // ));
    // Reduced timer for faster startup capability while still showing branding
    Timer(Duration(seconds: 3), () {
      Get.offNamed("/main");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Constants.kPrimary, // Changed from white to Green (Emerald)
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/grad_logo.png', height: 150), // Added Logo
              SizedBox(height: 20),
              Image.asset('assets/quranRail.png'),
              SizedBox(height: 15),
              Text(
                'AL Quran',
                style: TextStyle(
                  color: Colors.white, // Changed to white for contrast
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
