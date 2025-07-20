import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CalendarScreen extends StatefulWidget {
  final String userType;
  const CalendarScreen({Key? key, required this.userType}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  Set<DateTime> visitedDates = {};
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _loadVisitedDates();
    _markTodayAsVisited();
  }

  void _markTodayAsVisited() async {
    final prefs = await SharedPreferences.getInstance();
    DateTime today = DateTime.now();
    DateTime cleanDate = DateTime(today.year, today.month, today.day);

    setState(() {
      visitedDates.add(cleanDate);
    });

    // Save visitedDates to prefs
    List<String> stringDates =
        visitedDates.map((date) => date.toIso8601String()).toList();
    await prefs.setString('visited_dates', jsonEncode(stringDates));
  }

  void _loadVisitedDates() async {
    final prefs = await SharedPreferences.getInstance();
    String? saved = prefs.getString('visited_dates');

    if (saved != null) {
      List<String> stringDates = List<String>.from(jsonDecode(saved));
      setState(() {
        visitedDates = stringDates
            .map((dateStr) => DateTime.parse(dateStr))
            .map((d) => DateTime(d.year, d.month, d.day))
            .toSet();
      });
    }
  }

  bool _isVisited(DateTime day) {
    return visitedDates.contains(DateTime(day.year, day.month, day.day));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E13),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1217),
        title: const Text('Calendar', style: TextStyle(color: Colors.white)),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TableCalendar(
          firstDay: DateTime.utc(2024, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: CalendarFormat.month,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selected, focused) {
            setState(() {
              _selectedDay = selected;
              _focusedDay = focused;
            });
          },
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.purpleAccent,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: const Color(0xFF10B981),
              shape: BoxShape.circle,
            ),
            defaultTextStyle: const TextStyle(color: Colors.white),
            weekendTextStyle: const TextStyle(color: Colors.grey),
            outsideTextStyle: const TextStyle(color: Colors.grey),
            markerDecoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            markersMaxCount: 1,
          ),
          eventLoader: (day) => _isVisited(day) ? [day] : [],
          headerStyle: const HeaderStyle(
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
            formatButtonVisible: false,
            leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
            rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
