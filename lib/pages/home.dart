import 'package:flutter/material.dart';
import 'package:mood/widgets/mood_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _calendarKey = GlobalKey<State<MoodCalendar>>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: MoodCalendar(key: _calendarKey)));
  }
}
