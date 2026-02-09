import 'package:curved_navigation_bar/curved_navigation_bar.dart'; // Added
import 'package:flutter/material.dart';
import 'package:flutter_quran_yt/Constants/Constants.dart';
import 'package:flutter_quran_yt/Screens/QariScreen.dart';
import 'package:flutter_quran_yt/Screens/HomeScreen.dart';
import 'package:flutter_quran_yt/Screens/PrayerScreen.dart';
import 'package:flutter_quran_yt/Screens/QuranScreen.dart';
import 'package:flutter_quran_yt/Screens/TasbihScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectindex = 0;
  List<Widget> _widgetsList = [
    HomeScreen(),
    QuranScreen(),
    QariListScreen(),
    TasbihScreen(),
    PrayerScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: selectindex,
        children: _widgetsList,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: selectindex,
        height: 60.0,
        items: <Widget>[
          Image.asset('assets/home.png', height: 30, color: Colors.white),
          Image.asset('assets/holyQuran.png', height: 30, color: Colors.white),
          Image.asset('assets/audio.png', height: 30, color: Colors.white),
          Icon(Icons.fingerprint, size: 30, color: Colors.white),
          Image.asset('assets/mosque.png', height: 30, color: Colors.white),
        ],
        color: Constants.kPrimary,
        buttonBackgroundColor: Constants.kGold,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            selectindex = index;
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }

  void updateIndex(index) {
    setState(() {
      selectindex = index;
    });
  }
}
