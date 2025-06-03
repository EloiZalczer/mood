import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mood/models.dart';
import 'package:mood/widgets/mood_calendar.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _calendarKey = GlobalKey<State<MoodCalendar>>();

  void openMoodPicker(DateTime day) {
    // _calendarKey.currentState.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: MoodCalendar(key: _calendarKey)));
  }
}
