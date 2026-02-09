import 'package:flutter/material.dart';
import 'package:flutter_quran_yt/Constants/Constants.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({Key? key}) : super(key: key);

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  final List<Map<String, String>> prayers = [
    {"name": "Fajr", "time": "05:40 AM"},
    {"name": "Sunrise", "time": "07:05 AM"},
    {"name": "Dhuhr", "time": "12:15 PM"},
    {"name": "Asr (Hanafi)", "time": "03:45 PM"},
    {"name": "Maghrib", "time": "05:25 PM"},
    {"name": "Isha (Hanafi)", "time": "06:50 PM"},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.kPrimary,
        appBar: AppBar(
          title: const Text("Prayer Timings",
              style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// HEADER CARD
              Container(
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff00695c), // Lighter Teal
                      Constants.kPrimary
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    )
                  ],
                ),
                child: Stack(
                  children: [
                    // Background Image (Sajda) with BlendMode
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/sajda.jpg',
                          fit: BoxFit.cover,
                          color:
                              Constants.kPrimary.withOpacity(0.5), // Tint color
                          colorBlendMode: BlendMode.overlay,
                        ),
                      ),
                    ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Today's Prayers",
                                style: TextStyle(
                                  color: Constants.kGold, // Changed to Gold
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.access_time_filled,
                                  color: Constants.kGold, size: 30),
                            ],
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Bahawalpur, Pakistan",
                            style: TextStyle(
                              color: Constants.kGold, // Changed to Gold
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// PRAYER LIST
              Expanded(
                child: AnimationLimiter(
                  child: ListView.builder(
                    itemCount: prayers.length,
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 500),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: PrayerTile(
                              name: prayers[index]["name"]!,
                              time: prayers[index]["time"]!,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// SINGLE PRAYER TILE
class PrayerTile extends StatelessWidget {
  final String name;
  final String time;

  const PrayerTile({
    Key? key,
    required this.name,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05), // Glassmorphism
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          /// ICON
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white10,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.mosque,
              color: Constants.kGold,
            ),
          ),

          const SizedBox(width: 16),

          /// PRAYER NAME
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          /// TIME
          Text(
            time,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
