import 'package:flutter/material.dart';
import 'package:flutter_quran_yt/Constants/Constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

class StreakHistoryScreen extends StatefulWidget {
  final List<String> dates;
  const StreakHistoryScreen({Key? key, required this.dates}) : super(key: key);

  @override
  State<StreakHistoryScreen> createState() => _StreakHistoryScreenState();
}

class _StreakHistoryScreenState extends State<StreakHistoryScreen> {
  late Map<DateTime, List> _events;

  @override
  void initState() {
    super.initState();
    _events = {};
    for (var dateStr in widget.dates) {
      // Parse String "2024-1-1" back to DateTime
      // Note: simple format usage
      List<String> parts = dateStr.split('-');
      if (parts.length == 3) {
        DateTime date = DateTime.utc(
            int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
        if (_events[date] == null) _events[date] = [];
        _events[date]!.add("Visited");
      }
    }
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    // Normalize day to UTC for comparison
    DateTime normalizedDate = DateTime.utc(day.year, day.month, day.day);
    return _events[normalizedDate] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Streak History",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Constants.kPrimary,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Constants.kPrimary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Icon(Icons.local_fire_department,
                    color: Constants.kGold, size: 50),
                SizedBox(height: 10),
                Text(
                  "Keep it Up!",
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Every day counts towards your goal.",
                  style: TextStyle(color: Colors.white70),
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TableCalendar<dynamic>(
                firstDay: DateTime.utc(2023, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: DateTime.now(),
                eventLoader: _getEventsForDay,
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Constants.kPrimary.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Constants.kGold,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: Constants.kGold,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    if (events.isNotEmpty) {
                      return Positioned(
                        bottom: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Constants.kGold,
                          ),
                          width: 7.0,
                          height: 7.0,
                        ),
                      );
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
