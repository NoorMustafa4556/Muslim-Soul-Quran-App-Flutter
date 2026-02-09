import 'package:flutter/material.dart';
import 'package:flutter_quran_yt/Constants/Constants.dart';
import 'package:flutter_quran_yt/Screens/JusScreen.dart';
import 'package:flutter_quran_yt/Screens/MainScreen.dart';
import 'package:flutter_quran_yt/Screens/SplashScreen.dart';
import 'package:flutter_quran_yt/Screens/SurahDetail.dart';
import 'package:flutter_quran_yt/Screens/ChatScreen.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Muslim Soul',
      theme: ThemeData(
        primarySwatch: Constants.kSwatchColor,
        primaryColor: Constants.kPrimary,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: GoogleFonts.poppins().fontFamily, // Set Global Font
        appBarTheme: AppBarTheme(
          backgroundColor: Constants.kPrimary,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: GoogleFonts.poppins(
            color: Constants.kGold,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Constants.kPrimary,
        scaffoldBackgroundColor: Color(0xff121212),
        appBarTheme: AppBarTheme(backgroundColor: Constants.kPrimary),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      ),
      themeMode: ThemeMode.light, // Default start as light
      home: SplashScreen(),
      routes: {
        JuzScreen.id: (context) => JuzScreen(),
        Surahdetail.id: (context) => Surahdetail(),
        ChatScreen.id: (context) => ChatScreen(),
      },
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),
        GetPage(name: '/main', page: () => MainScreen()),
      ],
    );
  }
}
