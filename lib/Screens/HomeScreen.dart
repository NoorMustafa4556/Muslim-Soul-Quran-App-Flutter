import 'dart:ui';
import 'package:flutter_quran_yt/Widgets/CustomDrawer.dart';

import 'package:flutter/material.dart';
import 'package:flutter_quran_yt/Constants/Constants.dart';
import 'package:flutter_quran_yt/Models/AyaOfTheDay.dart';
import 'package:flutter_quran_yt/Services/ApiServices.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiServices _apiServices = ApiServices();
  late Future<AyaOfTheDay> _dailyAyaFuture;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void setData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("alreadyUsed", true);
  }

  @override
  void initState() {
    super.initState();
    setData();
    _dailyAyaFuture = _apiServices.getAyaOfTheDay(); // Fetch once
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    HijriCalendar.setLocal('ar');
    var _hijri = HijriCalendar.now();
    var day = DateTime.now();
    var format = DateFormat('EEE , d MMM yyyy');
    var formatted = format.format(day);

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey, // Assign Key
        drawer: const CustomDrawer(), // Add Drawer
        body: Column(
          children: [
            Container(
              height: _size.height * 0.22,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Constants.kPrimary,
                    Constants.kPrimary.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Stack(
                children: [
                  // Menu Button
                  Positioned(
                    top: 10,
                    left: 10,
                    child: IconButton(
                      icon: Icon(Icons.menu, color: Colors.white, size: 30),
                      onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                    ),
                  ),
                  Positioned(
                    right: -30,
                    bottom: -30,
                    child: Opacity(
                      opacity: 0.15,
                      child: Image.asset(
                        'assets/quran.png', // Switched to high-res quran.png
                        width: 250,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatted,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Assalamu'Alaikum",
                          style: TextStyle(
                            color: Constants.kGold, // Gold selection
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        RichText(
                          text: TextSpan(
                            children: <InlineSpan>[
                              TextSpan(
                                text: '${_hijri.hDay} ${_hijri.longMonthName} ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              TextSpan(
                                text: '${_hijri.hYear} AH',
                                style: TextStyle(
                                  color: Constants.kGold, // Gold Accent
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsetsDirectional.only(top: 10, bottom: 20),
                child: Column(
                  children: [
                    FutureBuilder<AyaOfTheDay>(
                      future: _dailyAyaFuture,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return Icon(Icons.sync_problem);
                          case ConnectionState.waiting:
                          case ConnectionState.active:
                            return CircularProgressIndicator();
                          case ConnectionState.done:
                            return Container(
                              margin: EdgeInsetsDirectional.all(16),
                              padding: EdgeInsetsDirectional.all(20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                      offset: Offset(0, 5),
                                      color:
                                          Constants.kPrimary.withOpacity(0.1),
                                    )
                                  ],
                                  border: Border.all(
                                    color: Constants.kPrimary.withOpacity(0.3),
                                    width: 1,
                                  )),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.menu_book_rounded,
                                          color: Constants.kPrimary),
                                      SizedBox(width: 8),
                                      Text(
                                        "Aya of the Day",
                                        style: TextStyle(
                                            color: Constants.kPrimary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    color: Constants.kPrimary.withOpacity(0.2),
                                    thickness: 1,
                                    height: 30,
                                  ),
                                  Text(
                                    snapshot.data!.arText!,
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        fontFamily:
                                            'Amiri' // Assuming custom Arabic font, or default
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    snapshot.data!.enTran!,
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 20),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color:
                                          Constants.kPrimary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: RichText(
                                      text: TextSpan(children: <InlineSpan>[
                                        TextSpan(
                                          text: "${snapshot.data!.surEnName} ",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Constants.kPrimary,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text:
                                              "| Ayah ${snapshot.data!.surNumber}",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Constants.kPrimary),
                                        ),
                                      ]),
                                    ),
                                  ),
                                ],
                              ),
                            );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
