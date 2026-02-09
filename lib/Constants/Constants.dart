import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Constants {
  // Emerald Green Theme
  static const kPrimary = Color(0xff004B40);
  static const kGold = Color(0xffCEA434); // Islamic Gold Accent
  static const kTvColor = Color(0xff00796B); // Lighter Emerald for gradients

  static const MaterialColor kSwatchColor = const MaterialColor(
    0xff004B40,
    const <int, Color>{
      50: const Color(0xffe0f2f1),
      100: const Color(0xffb2dfdb),
      200: const Color(0xff80cbc4),
      300: const Color(0xff4db6ac),
      400: const Color(0xff26a69a),
      500: const Color(0xff009688),
      600: const Color(0xff00897b),
      700: const Color(0xff00796b),
      800: const Color(0xff00695c),
      900: const Color(0xff004d40),
    },
  );

  static int? juzIndex;
  static int? surahIndex;
}
