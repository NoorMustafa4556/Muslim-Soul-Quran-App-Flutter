import 'package:flutter/material.dart';
import 'package:flutter_quran_yt/Constants/Constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_quran_yt/Screens/TasbihScreen.dart';
import 'package:flutter_quran_yt/Screens/PrayerScreen.dart';
import 'package:flutter_quran_yt/Screens/QuranScreen.dart';
import 'package:flutter_quran_yt/Screens/ChatScreen.dart';

import 'package:flutter_quran_yt/Screens/StreakHistoryScreen.dart'; // Import

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int streakDisplay = 0; // Restored
  List<String> streakDates = [];

  @override
  void initState() {
    super.initState();
    _updateStreak();
  }

  Future<void> _updateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final lastOpen = prefs.getString('last_streak_date');
    final currentStreak = prefs.getInt('current_streak') ?? 0;
    streakDates = prefs.getStringList('streak_dates') ?? [];

    final today = DateTime.now();
    final todayStr = "${today.year}-${today.month}-${today.day}";

    if (!streakDates.contains(todayStr)) {
      streakDates.add(todayStr);
      await prefs.setStringList('streak_dates', streakDates);
    }

    if (lastOpen == todayStr) {
      // Already opened today
      setState(() {
        streakDisplay = currentStreak;
      });
      return;
    }

    // Check if yesterday
    final yesterday = today.subtract(Duration(days: 1));
    final yesterdayStr =
        "${yesterday.year}-${yesterday.month}-${yesterday.day}";

    if (lastOpen == yesterdayStr) {
      // Streak continues
      final newStreak = currentStreak + 1;
      await prefs.setInt('current_streak', newStreak);
      setState(() {
        streakDisplay = newStreak;
      });
    } else {
      // Streak broken (or first time) but check if we have data
      // If it's a new day and not yesterday, we reset streak count but keep history
      await prefs.setInt('current_streak', 1);
      setState(() {
        streakDisplay = 1;
      });
    }

    // Save today as last open
    await prefs.setString('last_streak_date', todayStr);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            // Header with Kaba Banner
            Container(
              height: 260,
              decoration: BoxDecoration(
                color: Colors.black, // Fallback color
                image: DecorationImage(
                  image: AssetImage('assets/kaba.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4),
                      BlendMode.darken), // Darken image for better text
                ),
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 45, // Increased Size
                      backgroundColor: Colors.white,
                      backgroundImage:
                          AssetImage('assets/roza.png'), // Changed to Roza
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Welcome Back", // Changed Text
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 5.0,
                            color: Colors.black,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Dedicated Streak Tab/Section
            GestureDetector(
              onTap: () {
                Get.to(() => StreakHistoryScreen(dates: streakDates));
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Constants.kGold, // Corrected constant
                  gradient: LinearGradient(
                    colors: [Constants.kGold, Constants.kGold.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Constants.kGold.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    )
                  ],
                ),
                child: ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.local_fire_department,
                        color: Colors.white, size: 24),
                  ),
                  title: Text(
                    "Current Streak",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  subtitle: Text(
                    "$streakDisplay Days",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // Use Expanded for list to push footer to bottom
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    icon: FontAwesomeIcons.bookQuran,
                    title: "Read Quran",
                    onTap: () {
                      Get.back(); // Close drawer
                      Get.to(() => QuranScreen());
                    },
                  ),
                  _buildDrawerItem(
                    icon: FontAwesomeIcons.handsPraying,
                    title: "Prayer Times",
                    onTap: () {
                      Get.back();
                      Get.to(() => PrayerScreen());
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.fingerprint,
                    title: "Digital Tasbih",
                    onTap: () {
                      Get.back();
                      Get.to(() => TasbihScreen());
                    },
                  ),
                  _buildDrawerItem(
                    icon: FontAwesomeIcons.robot,
                    title: "Islamic AI Assistant",
                    onTap: () {
                      Get.back();
                      Get.to(() => ChatScreen());
                    },
                  ),
                  Divider(),
                  _buildDrawerItem(
                    icon: Icons.settings_display,
                    title: "Appearance",
                    onTap: () {}, // Submenu placeholder
                    trailing: Switch(
                      activeColor: Constants.kGold,
                      value: Get.isDarkMode,
                      onChanged: (val) {
                        Get.changeThemeMode(
                            val ? ThemeMode.dark : ThemeMode.light);
                        setState(() {}); // Updates UI
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "App Version 1.0.0",
                style: TextStyle(color: Colors.grey),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      {required IconData icon,
      required String title,
      required VoidCallback onTap,
      Widget? trailing}) {
    return ListTile(
      leading: Icon(icon, color: Constants.kPrimary),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
